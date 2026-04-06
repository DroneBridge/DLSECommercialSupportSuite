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

## Usage

The suite includes several example scripts demonstrating different functionalities. Before running any script, open it and check for configuration variables (like `MY_SECRET_TOKEN`, `ESP_SERIAL_PORT`, or IP addresses) that need to be updated for your environment.

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
| `--token` | Your secret token from [drone-bridge.com](https://drone-bridge.com). |
| `--release-folder` | Path to the folder containing the DLSE firmware binaries you downloaded in Step 3. |
| `--settings-file` | Path to the settings file you exported from the ESP32 web interface in Step 1. |
| `--start-index` | A numeric postfix appended to `ssid_ap`, `wifi_hostname`, and `ip_sta` for each flashed unit. For example, with `--start-index 33` the access point SSID becomes `<YOUR_SSID>33`. |

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
python batch_ota_update_allinone.py --release_folder "DroneBridge_ESP32DLSE_BETA3"  --subnetmask "192.168.1.0/24"
```
Or in case you want to target only ESP32s running a specific target version:
```bash
python batch_ota_update_allinone.py --release_folder "DroneBridge_ESP32DLSE_BETA3"  --subnetmask "192.168.1.0/24" --target-version "1.0.0-beta.3"
```
If a parameter is not supplied, all detected devices will be upgraded.

### Parameters

| Parameter | Description |
|---|---|
| `--release_folder` | Path to the root directory of the release, e.g. `DroneBridge_ESP32DLSE_BETA3`. |
| `--subnetmask` | IP address range to scan for devices. |
| `--target-version` | Only upgrade ESP32s running this specific DLSE version — all other devices are skipped. Use `"0.0.0-dev.1"` to target DLSE Beta4 and earlier, as all those versions identify with that version string. |

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

> [!CAUTION]
> Requires Skybrush Live to be turned off.
> Requires TX & RX GPIO pins to be configured and TRAIL mode being not expired in order to detect the ESP32

```bash
python batch_ota_license_activation.py --token <YOUR_SECRET_TOKEN> ----subnetmask "192.168.1.0/24" --esp32localbrcstport 14555 --esp32remotebrcstport 14550
```

### Parameters
*   `--token`: Your secret activation token received from `drone-bridge.com/dlse` user dashboard
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

## Key Scripts

*   **`batch_install_dlse_allinone.py`**:  Flashes board over a serial link. Batch installation script that takes care of it all. Applying settings, flashing & activation. It can pull license from the ESP32 prior to flashing in case the license server is not available.
*   **`batch_ota_license_activation.py`**: Installs DLSE licenses over the air (OTA) for all detected devices on the specified subnet.
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
