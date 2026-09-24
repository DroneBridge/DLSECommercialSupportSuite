# Changelog

## 1.1.1

### Added

- Bulk editing for compatible DLSE settings across checked Fleet Manager
  devices.

### Changed

- The Settings panel now shows shared values across the checked set and marks
  differences as mixed until explicitly edited.
- Bulk edits include only settings available with compatible types on every
  target, clear pending edits when the checked set changes, and require an
  explicit confirmation before target devices reboot.

## 1.1.0

### Added

- PySide6 Fleet Manager for discovering, inspecting, configuring, licensing,
  rebooting, and updating DLSE ESP32 fleets.
- Optional UniFi observations for access-point-side wireless metrics.
- Installed `dlse-ui` launcher alongside the existing `dlse-*` commands.

### Changed

- UI dependencies are installed by default so the GitHub Release wheel is
  immediately runnable without package extras.
- Runtime package data is limited to the assets required by the installed UI.

### Compatibility

- Windows x64 is the validated desktop platform for this release. Linux and
  macOS are expected to work but are not release-qualified.
- Python 3.10 and newer are supported. UniFi integration is guaranteed on
  Python 3.10 through 3.13 and is best-effort on newer Python versions.
- Existing command-line entry points and workflows remain available.
