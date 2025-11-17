#!/usr/bin/env python3
"""
Return GPU telemetry in a format Dark Material Shell expects.
Works with NVIDIA (via pynvml) and AMD/Intel via hwmon fallbacks.
"""

from __future__ import annotations

import glob
import json
import os
import sys
from typing import Dict, List, Tuple

try:
    import pynvml  # type: ignore
except Exception:  # pragma: no cover - pynvml optional
    pynvml = None


def _read_file(path: str) -> str | None:
    try:
        with open(path, "r", encoding="utf-8") as handle:
            return handle.read().strip()
    except (FileNotFoundError, PermissionError, OSError):
        return None


def _vendor_from_id(vendor_id: str | None) -> str:
    lookup = {
        "0x1002": "AMD",
        "0x1022": "AMD",
        "0x10de": "NVIDIA",
        "0x8086": "INTEL",
    }
    if not vendor_id:
        return "UNKNOWN"
    return lookup.get(vendor_id.lower(), vendor_id)


def collect_nvml() -> Tuple[List[Dict], List[str]]:
    """Collect GPU stats via NVML when available."""
    gpus: List[Dict] = []
    errors: List[str] = []

    if pynvml is None:  # pragma: no cover - optional dependency
        return gpus, []

    try:
        pynvml.nvmlInit()
        count = pynvml.nvmlDeviceGetCount()
        for idx in range(count):
            handle = pynvml.nvmlDeviceGetHandleByIndex(idx)
            name = pynvml.nvmlDeviceGetName(handle)
            memory_info = pynvml.nvmlDeviceGetMemoryInfo(handle)
            pci_info = pynvml.nvmlDeviceGetPciInfo(handle)
            temp = pynvml.nvmlDeviceGetTemperature(handle, pynvml.NVML_TEMPERATURE_GPU)

            pci_id = pci_info.busId.decode() if isinstance(pci_info.busId, bytes) else str(pci_info.busId)
            gpu_name = name.decode() if isinstance(name, bytes) else str(name)

            gpus.append(
                {
                    "index": idx,
                    "name": gpu_name,
                    "displayName": gpu_name,
                    "fullName": gpu_name,
                    "pciId": pci_id,
                    "temperature": temp,
                    "memoryUsed": memory_info.used,
                    "memoryTotal": memory_info.total,
                    "memoryUsedMB": memory_info.used // (1024 * 1024),
                    "memoryTotalMB": memory_info.total // (1024 * 1024),
                    "vendor": "NVIDIA",
                    "driver": "nvidia",
                }
            )
    except Exception as exc:  # pragma: no cover - nvml error path
        errors.append(f"NVML error: {exc}")
    finally:
        try:
            if pynvml is not None:
                pynvml.nvmlShutdown()
        except Exception:
            pass

    return gpus, errors


def collect_hwmon() -> Tuple[List[Dict], List[str]]:
    """Collect fallback telemetry for AMD/Intel via hwmon."""
    gpus: List[Dict] = []
    errors: List[str] = []

    for temp_path in glob.glob("/sys/class/drm/card*/device/hwmon/hwmon*/temp1_input"):
        raw = _read_file(temp_path)
        if raw is None:
            continue
        try:
            temperature = round(int(raw) / 1000)
        except ValueError:
            continue

        hwmon_dir = os.path.dirname(temp_path)
        device_dir = os.path.dirname(os.path.dirname(hwmon_dir))
        card_dir = os.path.dirname(device_dir)
        card_name = os.path.basename(card_dir)

        vendor_id = _read_file(os.path.join(device_dir, "vendor"))
        device_id = _read_file(os.path.join(device_dir, "device"))
        pci_slot = ""
        uevent = _read_file(os.path.join(device_dir, "uevent"))
        if uevent:
            for line in uevent.splitlines():
                if line.startswith("PCI_SLOT_NAME="):
                    pci_slot = line.split("=", 1)[1].strip()
                    break

        hwmon_name = _read_file(os.path.join(hwmon_dir, "name")) or ""
        vendor = _vendor_from_id(vendor_id)
        human_name = f"{vendor} {device_id or hwmon_name or card_name}".strip()

        gpus.append(
            {
                "index": len(gpus),
                "name": human_name,
                "displayName": human_name,
                "fullName": human_name,
                "pciId": pci_slot or card_name,
                "temperature": temperature,
                "vendor": vendor,
                "driver": "amdgpu" if "amd" in vendor.lower() or "amdgpu" in hwmon_name.lower() else vendor.lower(),
            }
        )

    return gpus, errors


def main() -> None:
    combined: Dict[str, Dict] = {}
    errors: List[str] = []

    nvml_gpus, nvml_errors = collect_nvml()
    hwmon_gpus, hwmon_errors = collect_hwmon()

    for gpu in nvml_gpus + hwmon_gpus:
        pci_id = gpu.get("pciId") or f"gpu-{gpu.get('index', len(combined))}"
        combined[pci_id] = gpu

    errors.extend(err for err in nvml_errors + hwmon_errors if err and "not available" not in err.lower())

    payload = {"gpus": list(combined.values())}
    if errors:
        payload["errors"] = errors

    print(json.dumps(payload))


if __name__ == "__main__":
    main()
