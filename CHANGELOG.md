# Changelog

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
