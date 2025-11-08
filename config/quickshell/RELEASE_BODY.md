## Assets

### Complete Packages
- **`dms-full-amd64.tar.gz`** - Complete package for x86_64 systems (CLI binaries + QML source + installation guide)
- **`dms-full-arm64.tar.gz`** - Complete package for ARM64 systems (CLI binaries + QML source + installation guide)

### Individual Components
- **`dms-cli-amd64.gz`** - DMS CLI binary for x86_64 systems
- **`dms-cli-arm64.gz`** - DMS CLI binary for ARM64 systems
- **`dms-distropkg-amd64.gz`** - DMS CLI binary built with distro_package tag for AMD64 systems
- **`dms-distropkg-arm64.gz`** - DMS CLI binary built with distro_package tag for ARM64 systems
- **`dms-qml.tar.gz`** - QML source code only

### Checksums
- **`*.sha256`** - SHA256 checksums for verifying download integrity

**Installation:** Extract the `dms-full-*.tar.gz` package for your architecture and follow the `INSTALL.md` instructions inside.

---

## What's Changed

- about tab: replace ansi art with logo (cf66d28)
- update readme (9cec6fd)
- layers: up texture quality (9292633)
- polkit: simplify service usage (7252d1e)
- confirm modal: spacing adjustment (3b5a951)
- power: resize confirmation modals (0b1c331)
- polkit: support for polkit escalation prompts (c5efd28)
- settings: wrap sidebar in flickable fixes #581 (505b636)
- dankdash: show mangowc/sway when on one (3c20e9e)
- dwl: don't always show tag 1 (1fb4eb3)

**Full Changelog**: https://github.com/AvengeMedia/DankMaterialShell/compare/v0.3.0...v0.3.1
