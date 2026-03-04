# DLSECommercialSupportSuite

Drone Light Show Edition Support Suite for DroneBridge for ESP32.

This suite provides tools and scripts to manage, configure, and license DroneBridge for ESP32 devices, specifically for the Drone Light Show Edition (DLSE).
**Build the tools you need for DroneBridge DLSE! Make use of a lot of alrady existing scripts and the library as well as a OpenAPI description on the WiFi configuration endpoint!**

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

## Batch Installation via Serial Manual for DLSE Drones
Example for a fully automated activation and installation of DLSE on a ESP32 connected via serial, including a pre-defined configuration:
Run the script first. Then plug in the ESP32 via serial.
```bash
python batch_install_dlse_allinone.py --token <YOUR_SECRET_TOKEN> --release_folder "DroneBridge_ESP32DLSE_BETA3" --settings-file my_parameters/dlse_my_params.csv --start-index 55
```

This script allows for batch processing of drones for a show. **Run it and just plug in your ESP32s one by one. It will flash, activate & configure your DLSE ESP32 all in one go!**

1. Manually setup an initial ESP32 with a working config for your show drone
   1. Use e.g. the [online flashing tool](https://drone-bridge.com/flasher/) to install DLSE to your ESP32
   2. Power-cycle the ESP32 and connect to the access point it created "DroneBridge for ESP32" using the default password "dronebridge"
   3. In your browser navigate to the web interface by going to [192.168.2.1](http://192.168.2.1)
   4. Configure the ESP32 according to your needs and test it with your show drone
   5. Manually activate it using the activation key from the bottom of the ESP32s webpage and your secret token from [drone-bridge.com](https://drone-bridge.com) to generate a license file using the [online generator](https://drone-bridge.com/licensegenerator/)
   6. Upload the license via the ESP32 web interface using "Manage License"
   7. Export the settings using the ESP32 web interface
2. Setup the DLSE Commercial Support Toolchain with commands specified above
3. [Download the latest DLSE release binaries](https://drone-bridge.com/dlse/) and extract them to the `DLSECommercialSupportSuite` folder
4. From now on it is automated, and you can automatically apply the configuration to all your ESP32s.
   Then inside `DLSECommercialSupportSuite` folder run:
   ```bash
   python batch_install_dlse_allinone.py --token <YOUR_SECRET_TOKEN> --release-folder "DroneBridge_ESP32DLSE_BETA3" --settings-file my_parameters/dlse_my_params.csv --start-index 55
   ```
   Where the `--release-folder` points to the folder with the DLSE binaries you downloaded   
   Where the `--settings-file` points to the file you exported from the ESP32 web interface during initial setup.    
   Where the `--start-index` For dynamically updating the DLSE parameters adding a postfix to `ssid_ap` (SSID in AccessPoint Mode), `wifi_hostname` (WiFi Hostname) and `ip_sta` (static IP address). With start-index 33 e.g. the `ssid_ap` will become `<APSSID_SET_BY_USER>33`   

The script above will:
*   Automatically request, register with your account and download a license with the license server of DroneBridge
*   Flash the DLSE raw firmware together with your specified settings and license
*   Offline activation mode if a local license file for the ESP32 is found in `/received_licenses` or if the ESP32 is already activated and gets flashed again (pulls & applies the license prior to writing new release over it)
*   Log all steps to `/logs`

Running the script multiple times requesting a license with the same activation key (ESP32 ID) will not result in the loss of multiple credits. Re-generation of a license is free of course.

## Batch Over-The-Air Update for DLSE Drones

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
If parameter is not supplied, all detected devices will be upgraded.

### Parameters

*   `--release_folder`: Path to the root directory of the release e.g. `DroneBridge_ESP32DLSE_BETA3`
*   `--subnetmask`: IP address range to scan for devices
*   `--target-version`: Specify the ESP32s DLSE version that you want to upgrade. If supplied as a parameters, only ESP32s running that version will be upgraded. All other devices will be skipped. Supply `--target-version "0.0.0-dev.1"` in case you want to target DLSE Beta4 and earlier. These versions are all identifying with `0.0.0-dev.1`.

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

# OpenAPI Description

Find the DroneBridge DLSE OpenAPI description here: `api_definiton/openapi_definition.yaml`

## License

MIT License
