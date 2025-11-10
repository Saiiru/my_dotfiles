#!/usr/bin/env python3
import json
import os
from pathlib import Path

def find_amd_gpu_hwmon():
    """Find the hwmon directory for the AMD GPU."""
    try:
        for hwmon_dir in Path('/sys/class/hwmon').iterdir():
            if 'amdgpu' in (hwmon_dir / 'name').read_text():
                return hwmon_dir
    except (FileNotFoundError, PermissionError):
        return None
    return None

def get_amd_gpu_temp(hwmon_path):
    """Get AMD GPU temperature from the hwmon path."""
    if not hwmon_path:
        return None

    try:
        # Common temperature files for amdgpu
        temp_files = ['temp1_input', 'temp2_input', 'temp3_input']
        for temp_file in temp_files:
            temp_path = hwmon_path / temp_file
            if temp_path.exists():
                # Temperature is in millidegrees Celsius
                temp_milli_c = int(temp_path.read_text())
                return temp_milli_c / 1000.0
    except (FileNotFoundError, PermissionError, ValueError):
        return None
    return None

def main():
    """Main function to get and print AMD GPU temperature as JSON."""
    hwmon_path = find_amd_gpu_hwmon()
    temperature = get_amd_gpu_temp(hwmon_path)

    output = {
        "gpus": []
    }

    if temperature is not None:
        output["gpus"].append({
            "driver": "amdgpu",
            "vendor": "AMD",
            "displayName": "AMD GPU",
            "name": "AMD GPU",
            "temperature": temperature,
            # Add dummy values for other fields the QML might expect
            "pciId": "",
            "memoryUsed": 0,
            "memoryTotal": 0,
            "memoryUsedMB": 0,
            "memoryTotalMB": 0
        })
    else:
        # If no GPU is found, return an empty list or an error
        output["error"] = "Could not read AMD GPU temperature. Please ensure you have 'amdgpu' driver and necessary permissions."

    print(json.dumps(output))

if __name__ == "__main__":
    main()
