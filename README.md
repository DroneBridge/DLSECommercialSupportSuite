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

1.  Clone the repository:
    ```bash
    git clone --recursive https://github.com/DroneBridge/DLSECommercialSupportSuite.git
    cd DLSECommercialSupportSuite
    ```

2.  Install the package and dependencies:
    ```bash
    pip install .
    ```

## Updating This Repository

Use the update script for your terminal to fetch the newest code from the configured GitHub remote default branch, currently `origin/main`. The scripts stash tracked local changes, pull with `--ff-only`, update submodules, and then reapply the stash. Untracked local files such as logs, received licenses, firmware folders, and local parameter exports are not stashed or deleted.

PowerShell:

```powershell
.\update_repository.ps1
```

Linux/macOS terminal:

```bash
chmod +x update_repository.sh
./update_repository.sh
```

To update from `origin/master` explicitly:

```powershell
.\update_repository.ps1 -Branch master
```

```bash
./update_repository.sh --branch master
```

If the pull or stash reapply reports conflicts, run `git status`, resolve the conflicts, and keep the generated stash until you have confirmed your local changes are restored.

## Usage

The suite includes several example scripts demonstrating different functionalities. Before running any script, open it and check for configuration variables (like `MY_SECRET_TOKEN`, `ESP_SERIAL_PORT`, or IP addresses) that need to be updated for your environment.

## PySide6 User Interface

The first UI workflow supports over-the-air DLSE license activation. It discovers ESP32s with MAVLink broadcast and/or HTTP scanning, displays detected devices in a filterable table, shows REST details for the selected ESP32, checks the DroneBridge license server every 5 seconds, and activates licenses only after an explicit confirmation.

Install the package with UI dependencies from the repository root:

```bash
python -m pip install -e .
```

Run the UI:

```bash
python -m ui
```

License activation requires a DroneBridge license server token. The UI preloads the token from `DRONEBRIDGE_SECRET_TOKEN` when the environment variable is set, or you can enter a token for the current session. The UI does not persist the token. Regular activated licenses use the existing default validity behavior, and evaluation licenses always request a fixed 60-day validity.

Activated licenses are cached in `received_licenses/` for offline recovery and serial batch flashing. Evaluation licenses are downloaded to a temporary location for immediate validation/upload only and are removed after use, so they do not get mixed into the offline activated-license cache.

The license server base URL is configured in `DroneBridgeCommercialSupportSuite.py` with `DLSE_LICENSE_SERVER_BASE_URL`. For local testing, point that constant or the relevant function argument to your local server base URL, for example `http://127.0.0.1:8000`; the suite appends `/api/license/generate` internally.

Before activating devices, make sure Skybrush Live is stopped, the ESP32s are reachable on the selected subnet, the configured UDP broadcast ports match the ESP32 settings, and `received_licenses/` is writable. HTTP scanning defaults to 20 concurrent probes with a 1 second per-host timeout to avoid flooding the network.

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

---

### Step 4 — Run the batch installation script

From this point on the process is fully automated. Inside the `DLSECommercialSupportSuite` folder, run:
```bash
python batch_install_dlse_allinone.py \
  --token <YOUR_SECRET_TOKEN> \
  --release-folder "DroneBridge_ESP32DLSE_BETA3" \
  --settings-file my_parameters/dlse_my_params.csv \
  --start-index 55
```

#### Parameters

| Parameter | Description |
|---|---|
| `--token` | Your secret token from [drone-bridge.com](https://drone-bridge.com). You can also set `DRONEBRIDGE_SECRET_TOKEN`; `--token` overrides the environment variable. |
| `--release-folder` | Path to the folder containing the DLSE firmware binaries you downloaded in Step 3. |
| `--settings-file` | Path to the settings file you exported from the ESP32 web interface in Step 1. |
| `--start-index` | A numeric postfix appended to `ssid_ap`, `wifi_hostname`, and `ip_sta` for each flashed unit. For example, with `--start-index 33`, the access point SSID becomes `<YOUR_SSID>33` and the static IP of the ESP32 will be `192.168.50.33` if your config has set `192.168.50.1` as static IP. |

#### What the script does

- Automatically requests a license from the DroneBridge license server and registers it with your account.
- Flashes the DLSE firmware together with your exported settings and the generated license.
- Falls back to **offline activation** if a local license file for the ESP32 is already present in `/received_licenses`, or if the device has previously been activated (the existing license is pulled and re-applied before the new firmware is written).
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
python batch_ota_update_allinone.py --release_folder "DroneBridge_ESP32DLSE_BETA3"  --subnetmask "192.168.1.0/24 --esp32localbrcstport 14555 --esp32remotebrcstport 14550"
```
Or in case you want to target only ESP32s running a specific target version:
```bash
python batch_ota_update_allinone.py --release_folder "DroneBridge_ESP32DLSE_BETA3"  --subnetmask "192.168.1.0/24" --target-version "1.0.0-beta.3 --esp32localbrcstport 14555 --esp32remotebrcstport 14550"
```
If a parameter is not supplied, all detected devices will be upgraded.

### Parameters

| Parameter | Description |
|---|---|
| `--release_folder` | Path to the root directory of the release, e.g. `DroneBridge_ESP32DLSE_BETA3`. |
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
Device discovery first uses MAVLink UDP broadcast. If no devices respond, the script falls back to an HTTP scan of the same `--subnetmask` using `GET /api/system/info` with 20 concurrent probes and a 1 second per-host timeout.

> [!CAUTION]
> Requires Skybrush Live to be turned off.
> Requires TX & RX GPIO pins to be configured and TRAIL mode being not expired in order to detect the ESP32

```bash
python batch_ota_license_activation.py --token <YOUR_SECRET_TOKEN> --subnetmask "192.168.1.0/24" --esp32localbrcstport 14555 --esp32remotebrcstport 14550
```

To request 60-day evaluation licenses only, add `-e`:

```bash
python batch_ota_license_activation.py --token <YOUR_SECRET_TOKEN> -e --subnetmask "192.168.1.0/24" --esp32localbrcstport 14555 --esp32remotebrcstport 14550
```

### Parameters
*   `--token`: Your secret activation token received from `drone-bridge.com/dlse` user dashboard
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
python batch_ota_reboot.py --subnetmask "192.168.1.0/24" --esp32localbrcstport 14555 --esp32remotebrcstport 14550
```

To force the slower but more reliable REST path for both discovery and reboot:

```bash
python batch_ota_reboot.py --force-rest --subnetmask "192.168.1.0/24" --http-timeout 1.0 --http-workers 20
```

### Parameters
*   `--subnetmask`: IP address range to scan for devices to reboot. Default: `192.168.1.0/24`.
*   `--esp32localbrcstport`: As configured in the ESP32 web interface (open on your ESP32) (`udp_local_port`). Default: `14555`.
*   `--esp32remotebrcstport`: As configured in the ESP32 web interface (open on your GCS) (`wifi_brcst_port`). Default: `14550`.
*   `--force-rest`: Skip MAVLink discovery and reboot through HTTP scan plus `POST /api/settings`.
*   `--http-timeout`: Per-host HTTP timeout for REST discovery and reboot requests. Default: `1.0` seconds.
*   `--http-workers`: Maximum concurrent HTTP scan and reboot workers. Default: `20`, capped at `64`.

## Key Scripts

*   **`batch_install_dlse_allinone.py`**:  Flashes board over a serial link. Batch installation script that takes care of it all. Applying settings, flashing & activation. It can pull license from the ESP32 prior to flashing in case the license server is not available.
*   **`batch_ota_license_activation.py`**: Installs DLSE licenses over the air (OTA) for all detected devices on the specified subnet.
*   **`batch_ota_reboot.py`**: Reboots all detected ESP32 DLSE devices using MAVLink broadcast first, with an HTTP settings-endpoint fallback or forced REST mode.
*   **`batch_ota_update_allinone.py`**: Updates firmware over the air for all detected devices on the specified subnet and with the specified firmware version.
*   **`DroneBridgeCommercialSupportSuite.py`**: The main library file containing helper functions.

## Examples on individual functions

*   **`example_esp32_get_license.py`**: Standalone script to request a license file using an activation key.
*   **`example_params_update_flash.py`**: Demonstrates how to update configuration parameters (like IP and Hostname) in the CSV and flash them.
*   **`example_esp32_ota_update.py`**: Performs an Over-The-Air (OTA) firmware update for all detected ESP32 DLSE devices. Turn off Skybrush Live to allow port binding by the script
*   **`example_esp32_download_log.py`** & **`example_esp32_download_log_MAVSDK.py`**: Examples for downloading logs from the flight controller via the ESP32 bridge.


# OpenAPI Description

Find the DroneBridge DLSE OpenAPI description here: `api_definiton/openapi_definition.yaml`

# Images

All images are for illustration purposes only and are generated by Google Gemini (AI)

# License

MIT License
