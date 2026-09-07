# DLSE Commercial Support Suite
Drone Light Show Edition Support Suite for DroneBridge for ESP32.

This suite provides tools and scripts to manage, configure, and license DroneBridge for ESP32 devices, specifically for the Drone Light Show Edition (DLSE).
**Build the tools you need for DroneBridge DLSE! Make use of a lot of already existing scripts and the library as well as an OpenAPI description on the WiFi configuration endpoint!**

> [!WARNING]
> The DroneBridge Commercial Support Suite is provided **without warranty of any kind** under the MIT License. Scripts may require adaptation to match your specific hardware setup, firmware versions, and environment. Always test the scripts before use and **test with a small batch of devices first** before running a full production operations.

<img alt="Gemini_Generated_Image_3phf5r3phf5r3phf" src="https://github.com/user-attachments/assets/e763160e-64ed-436d-ac22-1acc76c119d8" />

## Features

*   OpenAPI Definition

*   Functions to manage your DLSE devices
    *   Upload/Download DLSE License
    *   Get Activation Key via Wi-Fi
    *   Remote Reset of ESP32
    *   Scan for DLSE devices on the network
    *   Drone Log download
    *   Change settings via Wi-Fi
*   Ready to use scripts for:
    *   Batch Installation via Serial
    *   Batch Over-The-Air Firmware Update for DLSE Drones
    *   Batch Over-The-Air License Activation for DLSE Drones
    *   Batch Over-The-Air Reboot for DLSE Drones

## Prerequisites

*   Python 3.10 or higher
*   A DroneBridge account and license token (for licensing features)

## Installation

### Recommended Installation

Install the command-line tools from the latest GitHub release.

GitHub Releases:
[**Check the Github Releases**](https://github.com/DroneBridge/DLSECommercialSupportSuite/releases)

```bash
python -m pip install pipx
python -m pipx ensurepath
```

Open a new terminal and install.

```bash
pipx install https://github.com/DroneBridge/DLSECommercialSupportSuite/releases/download/v1.0.0/dlsecommercialsupportsuite-1.0.0-py3-none-any.whl
```

For newer releases, replace `v1.0.0` and the wheel filename with the version shown on the GitHub Releases page.

Open a new terminal and verify the commands are available:

```bash
dlse-activate --help
dlse-reboot --help
dlse-update --help
dlse-install --help
```

## PySide6 Fleet Manager

The desktop Fleet Manager supports direct standalone management of DLSE ESP32 fleets. It provides MAVLink and HTTP discovery, rolling REST hydration, table and matrix views, complete device inspection, settings templates, OTA license activation, REST or MAVLink reboot, and local-binary OTA firmware updates. Serial flashing is intentionally not exposed in this UI.

The interface is implemented with Qt Quick/QML from the exported Figma design in `ui/qml`. Python does not construct widgets or dialogs; it exposes typed inventory models and a `FleetController` to QML while the existing support library and background workers perform network operations. The application targets desktop displays, opens at 1298×804, and has a minimum window size of 1180×720.

Install the package with UI dependencies from the repository root.

### UI Description

The application starts on the connection-mode screen. Choose **Direct Standalone** to open Fleet Manager. Skybrush, UniFi, and Network Manager are displayed only as future integration points.

Scan settings persist across sessions and include the IPv4 subnet, MAVLink ports, discovery methods, discovery interval, HTTP timeout, and bounded concurrency. MAVLink and HTTP discovery run concurrently, and each discovery pass merges devices into the retained session fleet rather than replacing it. The default discovery interval is five seconds and HTTP concurrency is 20.

The same dialog has an independent **System Stats Polling** section for `GET /api/system/stats`. Background polling is enabled by default with a two-second target interval, one-second per-request timeout, 20 concurrent requests, and an offline threshold of three consecutive failures. The supported ranges are 1–3600 seconds, 0.1–30 seconds, 1–64 workers, and 1–20 failures. Polling uses no automatic retries. A successful response updates cached statistics and marks the device online.

After **Apply Changes** or bulk **Apply Settings** succeeds, the Fleet Manager waits three seconds for the ESP32s to reboot and then refreshes `GET /api/settings` for every affected device. The refreshed values update the table and inspector without requiring a network-wide scan. Devices whose settings request failed are not treated as refreshed; a failed follow-up request preserves the last cached settings and records a diagnostic.

Disabling stats polling cancels queued requests, ignores late results from that polling generation, and preserves cached statistics and the last known online/offline status. Re-enabling it starts a round immediately. Device discovery continues independently.

For large fleets, two seconds is a target rather than a guaranteed per-device interval. Polling rounds never overlap, and only the configured number of HTTP requests are active at once (default 20, maximum 64). If a round takes longer than two seconds, the next round waits for it to finish. For example, 2,000 devices at 100 ms average response time require roughly 10 seconds per round with 20 concurrent requests; unreachable devices can extend this further up to the configured timeout.

The footer reports discovery and stats polling separately. Discovery shows `STOPPED`, `WAITING`, `SCANNING`, or `ERROR`; stats polling shows `DISABLED`, `WAITING`, `POLLING`, or `ERROR`. Ordinary per-device request failures affect device health but do not set the global stats polling indicator to `ERROR`.

The fleet table starts with Hostname, IP, Activation Status, DLSE Firmware, Chip, Build Version, DLSE Configured MAVLink Sys ID, FC MAVLink Sys ID, DB APMODE SSID, DB APMODE CHANNEL, and DEVICE RSSI. When `show_en_syid_ip` is enabled, the configured MAVLink sys ID is always the final octet of the DLSE device's currently discovered IP address, including dynamically assigned addresses. Otherwise it uses the observed MAVLink discovery sys ID when available, then falls back to `show_man_sysid`. The FC MAVLink sys ID is read from `/api/system/stats` field `fc_sysid`; `-1`, `0`, missing, or invalid values display as `unknown`, while valid values range from `1` through `255`. When a known FC SYS ID differs from the DLSE configured SYS ID, both table cells use the red offline-status badge styling. Use **Configure Columns** to show or hide additional REST-backed settings such as DLSE mode, baud, local and remote UDP ports, power management, MAVLink heartbeat, and whether the sys ID is based on IP. Drag rows in the Configure Columns dialog to reorder visible columns. Drag a column header's right edge to resize that column; double-click the resize handle to restore its default width. Visible column order and custom widths are persisted across sessions.

Use **Align SYS IDs** to reconcile explicitly selected, licensed DLSE/FC pairs. Only devices with `EVALUATION` or `ACTIVATED` license status are processed. Choose **Based on DLSE IP address** to set the FC to the DLSE IP address last octet and enable `show_en_syid_ip`; **Based on FC SYS ID** to copy `/api/system/stats` `fc_sysid` into `show_man_sysid` and disable IP-based SYS IDs; or **Based on manual DLSE SYS ID** to set the FC to `show_man_sysid` and disable IP-based SYS IDs. FC-changing modes use the device's hydrated `udp_local_port`, falling back to the Scan Settings ESP32 port, require a matching MAVLink parameter echo before rebooting, and then require the FC to acknowledge the reboot command. The UI tries ArduPilot `SYSID_THISMAV` first, then PX4 `MAV_SYS_ID`; PX4 accepts IDs only from `1` through `250`. If the FC write or reboot is rejected, DLSE settings are not changed. The firmware remains responsible for refusing unsafe operations such as an armed FC reboot. Validate this operation on a small, non-production batch before fleet-wide use.

Use **Assign Static IPs** to configure the static network settings of selected DLSE devices. Only selected devices currently visible in the filtered table and carrying `EVALUATION` or `ACTIVATED` license status are processed; selected rows hidden by the search filter are excluded. Enter the starting static IP, subnet mask, and gateway. Addresses are assigned in the current table order, incrementing the final octet from `.1` through `.254`; after `.254`, the third octet increases and the final octet resumes at `.1`. The complete generated range must fit the entered subnet, use usable host addresses, keep the gateway inside the subnet, and avoid known retained-device IP conflicts. Each accepted `POST /api/settings` request reboots the DLSE, so the device stops responding at its old IP and the table updates to the new IP after acceptance. Test with a small, non-production batch before changing a full fleet.

The matrix view uses compact inspection cards optimized for high-density fleets. Each card centers the hostname, last two IP octets, RSSI, MAVLink system ID, and online/activation status; selection remains controlled from the table view.

The right-side ESP32 configuration panel can be resized by dragging its left edge. Double-click the resize handle to restore the default width. The chosen panel width is persisted across sessions.

The inspector's **Metrics** tab groups connection, serial/MAVLink, flight-controller, health, firmware/hardware, and license information into cards. Byte and message counters remain cumulative since boot. Directional serial throughput is calculated from the two latest successful stats polls using their actual elapsed time; it displays as `Calculating...` until a valid pair is available and resets its baseline when a device counter decreases. MAVLink loss is shown as both an absolute count and a percentage. Firmware fields unknown to this application remain visible in the **Other** card.

Settings values in the right-side panel, including Wi-Fi password fields, are shown as readable text so operators can verify device configuration before applying changes. License-server tokens are still session-only and are not persisted.

License activation requires a DroneBridge license server token. The UI preloads the token from `DRONEBRIDGE_SECRET_TOKEN`, or accepts it for the current session. Tokens are never persisted. Regular activated licenses use the existing permanent-license behavior, and evaluation licenses request a fixed 60-day validity. License-server availability is checked every 30 seconds.


### Operational Folder

Run the installed commands from the folder where you want operational files to live. Relative paths for firmware release folders, settings CSV files, `logs/`, and `received_licenses/` are resolved from your current terminal folder. Firmware release folders are external downloads and are not bundled into the Python package.


## Usage
Normal users should use the installed commands:

```bash
dlse-activate --token <YOUR_SECRET_TOKEN> --subnetmask 192.168.1.0/24
dlse-activate --token <YOUR_SECRET_TOKEN> -e
dlse-reboot --subnetmask 192.168.1.0/24
dlse-reboot --force-rest
dlse-update --release-folder DroneBridge_ESP32DLSE_BETA5 --subnetmask 192.168.1.0/24
dlse-install --token <YOUR_SECRET_TOKEN> --release-folder DroneBridge_ESP32DLSE_BETA5 --settings-file my_parameters/dlse_my_params.csv --start-index 55
```

The suite includes installable `dlse-*` commands for normal operation.

Before running hardware workflows, stop Skybrush Live when using MAVLink discovery, reboot, or OTA update paths. Serial flashing also requires OS access to the ESP32 serial port.

Configuration export uses the existing NVS-compatible `key,type,encoding,value` CSV format. For multi-device template application, static IP, subnet mask, gateway, hostname, and manual MAVLink system ID are excluded by default; the confirmation dialog allows changing the exclusion set.

Activation keys are intentionally shown in full in the fleet table and inspector. Tokens, activation keys, and license payloads remain masked in diagnostic output and are never persisted by the UI.

OTA updates accept a DroneBridge account release, a validated local release folder, or explicit `www.bin` and application binary paths. Account releases use a session-only license server token from the dialog or `DRONEBRIDGE_SECRET_TOKEN`, are downloaded into the local `dlse_releases/` cache, and are validated before any device upload starts. The UI uploads the web image first, waits two seconds, then uploads the application image that reboots the device. Queued updates can be cancelled, but active uploads are allowed to finish to avoid intentionally interrupting a transfer.

Before network operations, make sure the ESP32s are reachable, configured UDP ports match, and Skybrush Live is stopped when MAVLink ports are required. Test activation, settings, reboot, and OTA operations on a small hardware batch before using them on a production fleet. Hardware workflows were not exercised by the automated test suite.

The default automated test run skips checks that require a physical ESP32 or the production license server. Set `DLSE_RUN_HARDWARE_TESTS=1` only with a test ESP32 connected, optionally selecting its port with `DLSE_TEST_SERIAL_PORT` (default `COM18`). Set `DLSE_RUN_NETWORK_TESTS=1` to include the live license-server availability check.

The Web Interface inspector uses Qt WebEngine Quick and is instantiated only after an online device is selected and the tab is opened. Linux deployments must provide the normal Qt runtime system libraries. Geist and Geist Mono are bundled under the SIL Open Font License 1.1, together with the application icons and other design assets, so the UI performs no runtime asset downloads.

## Automated DLSE Batch Installation
<img alt="Gemini_Generated_Image_kvejvukvejvukvej" src="https://github.com/user-attachments/assets/a069d8a4-fb42-4b4c-b2d6-70a67f0ac5ed" />
This script allows for batch processing of drones for a show.

**Run it and plug in your ESP32s one by one. It will flash, activate & configure your DLSE ESP32 all in one go!**

### Step 1 — Manually configure your reference ESP32

Set up one ESP32 with a working configuration to serve as the template for all your show drones.

1. Use the [online flashing tool](https://drone-bridge.com/flasher/) to install DLSE onto your ESP32.
2. Power-cycle the ESP32 and connect to the Wi-Fi access point it creates:
   - **SSID:** `DroneBridge for ESP32`
   - **Password:** `dronebridge`
3. Open the web interface in your browser at [192.168.2.1](http://192.168.2.1).
4. Configure the ESP32 to match your show drone setup and verify everything works.
5. At the bottom of the ESP32 web interface, copy the **activation key**. Then use it together with your **secret token** from [drone-bridge.com](https://drone-bridge.com) to generate a license file via the [online generator](https://drone-bridge.com/licensegenerator/).
6. Upload the license file in the ESP32 web interface under **Manage License**.
7. Export your settings from the ESP32 web interface — you will reference this file in the batch script later.

---

### Step 2 — Set up the DLSE Commercial Support Toolchain

Follow the setup commands described above to install the toolchain on your machine.

---

### Step 3 — Download the DLSE firmware binaries

[Download the latest DLSE release binaries](https://drone-bridge.com/dlse/) and extract them into the `DLSECommercialSupportSuite` folder.

The support library can also list the DLSE releases available to your account via
the DroneBridge license server and download a selected release zip into the local
`dlse_releases/` cache. Extracted releases in that folder are operational data
and are ignored by git. The batch scripts still accept `--release-folder`, so you
can continue to point them at any manually downloaded and extracted release root
folder.

---

### Step 4 — Run the batch installation script

From this point on the process is fully automated. Run the following command to install on all ESP32 serial devices connected to your computer:
```bash
dlse-install \
  --token <YOUR_SECRET_TOKEN> \
  --release-folder "DroneBridge_ESP32DLSE_BETA3" \
  --settings-file my_parameters/dlse_my_params.csv \
  --start-index 55
```

To request 60-day evaluation licenses instead of regular activated licenses, add `-e`:

```bash
dlse-install \
  --token <YOUR_SECRET_TOKEN> \
  -e \
  --release-folder "DroneBridge_ESP32DLSE_BETA3" \
  --settings-file my_parameters/dlse_my_params.csv \
  --start-index 55
```

#### Parameters

| Parameter | Description |
|---|---|
| `--token` | Your secret token from [drone-bridge.com](https://drone-bridge.com). You can also set `DRONEBRIDGE_SECRET_TOKEN`; `--token` overrides the environment variable. |
| `-e`, `--evaluation` | Request 60-day evaluation licenses instead of regular activated licenses. Evaluation licenses require license server access and are not cached in `received_licenses/`. |
| `--release-folder` | Path to the folder containing the DLSE firmware binaries you downloaded in Step 3. If omitted, the script asks you to choose a cached release from `dlse_releases/`, download an available online release, or enter a manual folder path. |
| `--settings-file` | Path to the settings file you exported from the ESP32 web interface in Step 1. If omitted while using the release selector, the script uses `db_show_params.csv` from the selected release. |
| `--start-index` | A numeric postfix appended to `ssid_ap`, `wifi_hostname`, and `ip_sta` for each flashed unit. For example, with `--start-index 33`, the access point SSID becomes `<YOUR_SSID>33` and the static IP of the ESP32 will be `192.168.50.33` if your config has set `192.168.50.1` as static IP. |

#### What the script does

- Automatically requests a license from the DroneBridge license server and registers it with your account.
- Flashes the DLSE firmware together with your exported settings and the generated license.
- Falls back to **offline activation** if a local license file for the ESP32 is already present in `/received_licenses`, or if the device has previously been activated (the existing license is pulled and re-applied before the new firmware is written).
- In evaluation mode, temporary 60-day licenses require the license server and are not stored in `/received_licenses`.
- Logs all actions to `/logs`.

> [!NOTE]
> Running the script multiple times for the same ESP32 (identified by its activation key) will **not** consume additional license credits. Re-generating a license is always free.

## Batch Over-The-Air Firmware Update for DLSE Devices
<img alt="Gemini_Generated_Image_o10ugso10ugso10u" src="https://github.com/user-attachments/assets/a3158a18-723f-4c0b-99ff-962e029371d8" />

Update the firmware of your drone swarm over the air.

> [!CAUTION]
> Requires Skybrush Live to be turned off.
> Requires TX & RX GPIO pins to be configured and TRAIL mode being not expired in order to detect the ESP32

```bash
dlse-update --release-folder "DroneBridge_ESP32DLSE_BETA3" --subnetmask "192.168.1.0/24" --esp32localbrcstport 14555 --esp32remotebrcstport 14550
```
Or in case you want to target only ESP32s running a specific target version:
```bash
dlse-update --release-folder "DroneBridge_ESP32DLSE_BETA3" --subnetmask "192.168.1.0/24" --target-version "1.0.0-beta.3" --esp32localbrcstport 14555 --esp32remotebrcstport 14550
```
If a parameter is not supplied, all detected devices will be upgraded.

### Parameters

| Parameter | Description |
|---|---|
| `--release-folder` | Path to the root directory of the release, e.g. `DroneBridge_ESP32DLSE_BETA3`. If omitted, the script asks you to choose a cached release from `dlse_releases/`, download an available online release, or enter a manual folder path. |
| `--token` | Optional token used only for listing and downloading releases when `--release-folder` is omitted. You can also set `DRONEBRIDGE_SECRET_TOKEN`; `--token` overrides the environment variable. |
| `--subnetmask` | IP address range to scan for devices. |
| `--target-version` | Only upgrade ESP32s running this specific DLSE version — all other devices are skipped. Use `"0.0.0-dev.1"` to target DLSE Beta4 and earlier, as all those versions identify with that version string. |
| `--esp32localbrcstport` | As configured in the web interface of the ESP32 (open on your ESP32) (udp_local_port) - Default: 14555 |
| `--esp32remotebrcstport` | As configured in the web interface of the ESP32 (open on your GCS) (wifi_brcst_port) - Default: 14550 |

### Example Output

```bash
Created log file logs\dlse_ota_update_log_20260304_231534.log
[2026-03-04 23:15:34] Using release folder: DroneBridge_ESP32DLSE_BETA4
[2026-03-04 23:15:34]     Found binaries for ESP32C3 in 'DroneBridge_ESP32DLSE_BETA4\esp32c3_generic'
[2026-03-04 23:15:34]     Found binaries for ESP32C5 in 'DroneBridge_ESP32DLSE_BETA4\esp32c5_generic'
[2026-03-04 23:15:34]     Found binaries for ESP32C6 in 'DroneBridge_ESP32DLSE_BETA4\esp32c6_generic'
[2026-03-04 23:15:34]   ✅ All required release binaries are present in 'DroneBridge_ESP32DLSE_BETA4'
[2026-03-04 23:15:34] Starting OTA update of all ESP32 devices in the local network
[2026-03-04 23:15:34] *** TURN OFF SKYBRUSH LIVE to free up the broadcast port ***
[2026-03-04 23:15:34] Your settings and license will be unaffected by this update.
[2026-03-04 23:15:34] Scanning network 192.168.1.0/24 (Broadcast: 192.168.1.255) for ESP32 devices...
[2026-03-04 23:15:37] 	Found 2 ESP32 (DLSE) device(s).
[2026-03-04 23:15:37] 	[ ] IP 192.168.1.174 SYS_ID: 174 - firmware Version 1.0.0-beta.4
[2026-03-04 23:15:37] 	[X] IP 192.168.1.206 SYS_ID: 206 - firmware Version 0.0.0-dev.1

Do you want to proceed with the OTA update for the selected [x] devices? (y/n): y
[2026-03-04 23:15:49] Skipping device 192.168.1.174 as it is not running the required target version 0.0.0-dev.1
[2026-03-04 23:15:49] Updating device 192.168.1.206 ...
[2026-03-04 23:15:49] Requesting system info from http://192.168.1.206/api/system/info (attempt 1/4)...
Request successful.
{"status": "success", "msg": "HTTP OTA www update successful!"}
Uploading 'DroneBridge_ESP32DLSE_BETA4\esp32c6_generic\db_esp32.bin' to 'http://192.168.1.206/update/firmware' with progress...
Uploading: 100%|██████████| 1.11M/1.11M [00:14<00:00, 77.4kB/s]

✅ Upload successful!
Status Code: 200
{"status": "success", "msg": "HTTP OTA app update successful! Rebooting ..."}
[2026-03-04 23:16:09] OTA update finished. 1 devices updated successfully. 0 devices failed to update.
[2026-03-04 23:16:09]
⚠️ Failed devices:
  (none)
[2026-03-04 23:16:09]
✅ Successful devices:
  - {'key': ('192.168.1.206', 206, 240), 'ip': '192.168.1.206', 'sys_id': 206, 'comp_id': 240, 'middleware_sw_version': 0, 'os_sw_version': 0, 'board_version': 0, 'vendor_id': 0, 'product_id': 0, 'mac': 0, 'flight_sw_version': {'major': 0, 'minor': 0, 'patch': 0, 'release_num': 1, 'type': 'dev', 'version_str': '0.0.0-dev.1'}}
```

## Batch Over-The-Air License Activation for DLSE Drones
<img alt="Gemini_Generated_Image_scabxascabxascab" src="https://github.com/user-attachments/assets/6152d740-2bde-496f-b818-a8bf9077b872" />
Activates all ESP32s on the subnet by requesting a license from the license server and installing it via a WiFi connection. Requires Skybrush Live to be turned off.    
For the most robust discovery behavior, run the script with `--force-rest`. This skips MAVLink discovery and uses an HTTP scan of the selected `--subnetmask` with `GET /api/system/info`, 20 concurrent probes, and a 1 second per-host timeout. If `--force-rest` is omitted, discovery first uses MAVLink UDP broadcast and falls back to the same HTTP scan only when no devices respond.

> [!CAUTION]
> Requires Skybrush Live to be turned off.
> Requires TX & RX GPIO pins to be configured and TRAIL mode being not expired in order to detect the ESP32

```bash
dlse-activate --token <YOUR_SECRET_TOKEN> --force-rest --subnetmask "192.168.1.0/24" --esp32localbrcstport 14555 --esp32remotebrcstport 14550
```

To request 60-day evaluation licenses only, add `-e`:

```bash
dlse-activate --token <YOUR_SECRET_TOKEN> --force-rest -e --subnetmask "192.168.1.0/24" --esp32localbrcstport 14555 --esp32remotebrcstport 14550
```

**After activating the ESP32s you might need to reboot them to re-activate the MAVLink processing up to DLSE BETA6 releases.** Do it manually or use the Batch Over-The-Air Reboot Script shown further down below.

### Parameters
*   `--token`: Your secret activation token received from `drone-bridge.com/dlse` user dashboard
*   `--force-rest`: Skip MAVLink discovery and scan the selected IP range with the ESP32 REST API. Recommended for the most robust discovery behavior.
*   `-e`, `--evaluation`: Request 60-day evaluation licenses instead of activated licenses. Evaluation licenses are temporary and are not stored in `received_licenses/`.
*   `--subnetmask`: IP address range to scan for devices to activate
*   `--esp32localbrcstport`: As configured in the web interface of the ESP32 (open on your ESP32) (udp_local_port)
*   `--esp32remotebrcstport`: As configured in the web interface of the ESP32 (open on your GCS) (wifi_brcst_port)

### Example Output

```bash
[2026-03-04 23:34:06] Starting DLSE Over-The-Air activation service. License storage: received_licenses
[2026-03-04 23:34:08] Scanning network 192.168.1.0/24 (Broadcast: 192.168.1.255) for ESP32 devices...
[2026-03-04 23:34:10] 	Found 0 ESP32 (DLSE) device(s).
[2026-03-04 23:34:18] Scanning network 192.168.1.0/24 (Broadcast: 192.168.1.255) for ESP32 devices...
[2026-03-04 23:34:20] 	Found 0 ESP32 (DLSE) device(s).
[2026-03-04 23:34:28] Scanning network 192.168.1.0/24 (Broadcast: 192.168.1.255) for ESP32 devices...
[2026-03-04 23:34:30] 	Found 1 ESP32 (DLSE) device(s).
[2026-03-04 23:34:31] Requesting license from https://drone-bridge.com/api/license/generate... (attempt 1/3)
[2026-03-04 23:34:31] ✅ License generated and saved to 'received_licenses/mKM*****DQIA.dlselic'
[2026-03-04 23:34:31] Validating license...
[2026-03-04 23:34:31] ✅ License signature is valid.
[2026-03-04 23:34:31] ✅ License matches activation key mKM*****DQIA
[2026-03-04 23:34:32] 🔑 Activated 192.168.1.149 - mKM*****DQIA 🔑
[2026-03-04 23:34:38] Scanning network 192.168.1.0/24 (Broadcast: 192.168.1.255) for ESP32 devices...
[2026-03-04 23:34:40] 	Found 1 ESP32 (DLSE) device(s).
[2026-03-04 23:34:42] 👋 Exiting auto license activation tool.
[2026-03-04 23:34:42] Session total: 1 devices activated or already activated
[2026-03-04 23:34:42] All licenses stored in: received_licenses
[2026-03-04 23:34:42] Processed IPs: {'192.168.1.149'}
[2026-03-04 23:34:42] Processed activation keys: {'mKM*****DQIA'}
```

## Batch Over-The-Air Reboot for DLSE Devices

Reboot all detected ESP32 DLSE devices in one confirmed operation. The script first tries MAVLink discovery. If at least one ESP32 is discovered, it sends one MAVLink broadcast reboot command to the subnet broadcast address. If MAVLink discovers no devices, it falls back to HTTP discovery with `GET /api/system/info` and reboots each detected device by sending `{}` to `POST /api/settings`.

> [!CAUTION]
> Requires Skybrush Live to be turned off when using MAVLink discovery or reboot, because the broadcast port must be available.
> The script asks for confirmation before sending reboot commands. Test with a small batch before rebooting a full fleet.

```bash
dlse-reboot --subnetmask "192.168.1.0/24" --esp32localbrcstport 14555 --esp32remotebrcstport 14550
```

To force the slower but more reliable REST path for both discovery and reboot:

```bash
dlse-reboot --force-rest --subnetmask "192.168.1.0/24" --http-timeout 1.0 --http-workers 20
```

### Parameters
*   `--subnetmask`: IP address range to scan for devices to reboot. Default: `192.168.1.0/24`.
*   `--esp32localbrcstport`: As configured in the ESP32 web interface (open on your ESP32) (`udp_local_port`). Default: `14555`.
*   `--esp32remotebrcstport`: As configured in the ESP32 web interface (open on your GCS) (`wifi_brcst_port`). Default: `14550`.
*   `--force-rest`: Skip MAVLink discovery and reboot through HTTP scan plus `POST /api/settings`.
*   `--http-timeout`: Per-host HTTP timeout for REST discovery and reboot requests. Default: `1.0` seconds.
*   `--http-workers`: Maximum concurrent HTTP scan and reboot workers. Default: `20`, capped at `64`.

## Key Scripts

*   **`dlse-install`** / **`batch_install_dlse_allinone.py`**:  Flashes board over a serial link. Batch installation script that takes care of it all. Applying settings, flashing & activation. It can pull license from the ESP32 prior to flashing in case the license server is not available.
*   **`dlse-activate`** / **`batch_ota_license_activation.py`**: Installs DLSE licenses over the air (OTA) for all detected devices on the specified subnet.
*   **`dlse-reboot`** / **`batch_ota_reboot.py`**: Reboots all detected ESP32 DLSE devices using MAVLink broadcast first, with an HTTP settings-endpoint fallback or forced REST mode.
*   **`dlse-update`** / **`batch_ota_update_allinone.py`**: Updates firmware over the air for all detected devices on the specified subnet and with the specified firmware version.
*   **`DroneBridgeCommercialSupportSuite.py`**: The main library file containing helper functions.

## Examples on individual functions

*   **`example_esp32_get_license.py`**: Standalone script to request a license file using an activation key.
*   **`example_params_update_flash.py`**: Demonstrates how to update configuration parameters (like IP and Hostname) in the CSV and flash them.
*   **`example_esp32_ota_update.py`**: Performs an Over-The-Air (OTA) firmware update for all detected ESP32 DLSE devices. Turn off Skybrush Live to allow port binding by the script
*   **`example_esp32_download_log.py`** & **`example_esp32_download_log_MAVSDK.py`**: Examples for downloading logs from the flight controller via the ESP32 bridge.


# OpenAPI Description

Find the DroneBridge DLSE OpenAPI description here: `api_definiton/openapi_definition.yaml`


# Installation for Development Setups

1.  Clone the repository:
    ```bash
    git clone --recursive https://github.com/DroneBridge/DLSECommercialSupportSuite.git
    cd DLSECommercialSupportSuite
    ```

2.  Install the package and dependencies:
    ```bash
    pip install .
    ```

3.  Run scripts directly from the source checkout when developing or debugging:
    ```bash
    python batch_ota_license_activation.py --token <YOUR_SECRET_TOKEN>
    python batch_ota_reboot.py
    python batch_ota_update_allinone.py --release-folder DroneBridge_ESP32DLSE_BETA5
    python batch_install_dlse_allinone.py --token <YOUR_SECRET_TOKEN> --release-folder DroneBridge_ESP32DLSE_BETA5 --settings-file my_parameters/dlse_my_params.csv --start-index 55
    ```

## Release Build Checklist

Build the wheel and source distribution from the repository root:

```bash
python -m pip install build
python -m build
```

If an existing local `build/` folder shadows the Python `build` module, run the command from the parent folder instead:

```bash
python -m build DLSECommercialSupportSuite
```

Smoke-test the wheel in an isolated `pipx` environment before publishing:

```bash
pipx install dist/DLSECommercialSupportSuite-<version>-py3-none-any.whl
dlse-activate --help
dlse-reboot --help
dlse-update --help
dlse-install --help
```

Attach the generated wheel and source archive to GitHub Releases if users should install from release artifacts instead of PyPI.

# Images

All images are for illustration purposes only and are generated by Google Gemini (AI)

# License

MIT License
