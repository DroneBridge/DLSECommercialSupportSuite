# List of requirements for the UI of the Commercial Support Suite

## Goal
  - All functions of the user interface shall use the existing functionality of the Commercial Support Suite `DroneBridgeCommercialSupportSuite.py`.
  - All functions of the user interface shall respect existing flows for the `batch_ota_update_allinone.py`, `batch_ota_license_activation.py` and `batch_install_dlse_allinone.py` since they are already implemented and are robust.
  - The user interface should support all functionality of the Commercial Support Suite.
  - The user interface shall be designed to manage up to 5000 ESP32s. This shall be respected when considering the size and layout of the user interface, as well as the performance and update rates.
  - The user interface shall work on Windows, Linux and MacOS.
  - The primary interface to the ESP32s shall be the REST:API. In the future, there shall be an option to use the MAVLink interface or a Ubiquity interface or a combination of all.
  - Flashing the ESP32s via serial shall not be in scope of this UI for now.

## Intermediate Goals
  - The user interface shall support the `batch_ota_license_activation.py` process.
    - This includes ESP32 discovery using UDP broadcast with MAVLink
    - This includes ESP32 discovery using automated batch IP scanning of a provided IP range
  - The user interface shall support the `batch_ota_reboot.py` process.
  - The user interface shall support the `batch_ota_update_allinone.py` process.
  - The listed features and user interface apply to the "Fleet Manager" user interface of the application only.

## Features
- The user interface should support all major features of the Commercial Support Suite: OTA Update, OTA Reboot, OTA Activation, Reading Settings from all detected devices, Applying Settings to individual devices or all selected devices.
- Specifically, the user interface should support the following:
  - Detection of all online ESP32s in the local network based on the IP address range that can be specified by the user, the application shall then scan each IP address in the range and send a http request to the ESP32s to check if they are online.
  - Detection of all online ESP32s in the local network based on the MAVLink response received from the ESP32s, when sending a broadcast MAVLink message.
  - Display of the online ESP32s in the local network. The display shall be updated automatically. The user shall be able to toggle the display between list and matrix/table view.
  - Run device discovery at the user-configured interval while retaining and merging previously detected devices.
  - Poll `/api/system/stats` for every retained device with a target interval of two seconds, bounded concurrency, and no overlapping rounds. For large fleets, extend the effective per-device interval instead of flooding the network.
  - Allow background `/api/system/stats` polling to be disabled while preserving cached data and last known online state. Expose independent interval, timeout, concurrency, and offline-failure-threshold settings.
  - Display separate footer indicators for discovery and stats polling activity and worker-level errors.
- The user interface should support the following features:
  - The user clicks on the "Scan for Devices" button to start and stop the scanning for online DLSE ESP32 devices.
  - Next to the button "Scan for Devices" there is a settings button that opens a scan settings dialog where the user can adjust the settings relevant for scanning like the scanning method (MAVLink broadcast, Unifi or IP range based). These settings shall persists over sessions.
  - The user shall be able to change the IP address range that is scanned for ESP32s.
  - The user shall be able to filter and search the displayed ESP32s by their name, IP address, MAC, Activation Key, Hostname, basically any data field that is received from the ESP32s via REST:API `/api/system/info`, `/api/settings` or `/api/system/stats`
  - The user shall be able to change the discovery rate and the adaptive runtime-statistics polling parameters in the scanning settings.
  - Once a ESP32 device is detected all parameters shall be requested from it via REST:API `/api/system/info`, `/api/settings` or `/api/system/stats`. It might be helpful to store them in a data scructure internally per detected ESP32.
  - The user interface shall support the over the air update of the ESP32s respecting the flows of the `batch_ota_update_allinone.py`.
  - The user interface shall support the activation of the ESP32s using the license server (support for evaluation and regular licenses). Allow the user to choose which license to pick and respecting `batch_ota_license_activation.py`. Clicking the "OTA DLSE Activation" Button shall prompt the user for the necessary information (token, activate all detected devices or just the selected ones, license type like ACTIVATED or EVALUATION).
  - The status of the activation and over the air update shall be displayed per ESP32 in the user interface.
  - When selecting an ESP32 in the user interface, the user shall be able to see the detailed information of the ESP32 including the information from the REST:API `/api/system/info` and `/api/settings`. This information shall be displayed inside the collapsable side on the right of the user interface. The user shall be able to resize this right-side panel by dragging it with the mouse.
  - The web interface tab being part of the collapsable side bar in the UI shall display the website of the DLSE device. The website can be retrieved by getting `http://<ip_esp32>`
  - The user interface may store and update a local copy of the ESP32s parameters. Like a local data model if it makes sense from an architectural point of view.
  - Possibility to update selected or all detected devices firmware OTA (provide inputs based on OTAs function signagure/parameters). The progress of the OTA update shall be visible in the UI in the form of a progress indicator in the detected device table. The user can choose to manually provide a custom image (www.bin & dlse_esp32.bin) or download/choose a default DLSE image that was downloaded from the server automatically.
  - It shall be possible to update multiple devices OTA in parallel (configuration parameter defaults to 20)
  - Option to download the configuration as a .csv file from the selected devices using a button in the settings tab on the right side of the user interface.
  - Option to upload the configuration as a .csv file to the selected or all detected devices. Option to provide the .csv file from disk using a file chooser.
  - Inside the table the user can choose what columns shall be visible by clicking on the "Configure Columns" button. A popup with all available columns shall appear that lets the user pick the ones that shall be visible and rearrange the visible column order. The user shall be able to manually resize individual visible columns.
  - By default the columns for the parameter: Hostname, IP, Activation Status, Firmware version, Chip, Build Version, DLSE Configured MAVLink Sys ID, FC MAVLink Sys ID, DB APMODE SSID, DB APMODE CHANNEL, DEVICE RSSI
  - Optional REST-backed table columns shall include DLSE Mode (`esp32_mode`), Baud (`baud`), DLSE Local UDP Port (`udp_local_port`), DLSE Remote UDP Port (`wifi_brcst_port`), Power Management (`show_pm_en`), DLSE MAVLink Heartbeat (`show_pm_en_hb`), and DLSE MAVLink Sys ID Based On IP (`show_en_syid_ip`).
  - The user interface shall display the license server connection status (Online/Offline). The status shall be updated every 10s.
  - There shall be the option to provide the user token for the DLSE license server via an environment variable named "DRONEBRIDGE_SECRET_TOKEN"


## User Interface Framework
- Use PySide6

## Design Language

- The user interface shall use material icons from google fonts: https://github.com/google/material-design-icons/tree/master/png - outlined with weight of 200 and no fill. Alternatively the symbols are available offline as `.ttf` files: `\ui\resources\Material_Symbols_Outlined`
  - material-symbols-outlined: font-variation-settings: 'FILL' 0, 'wght' 200, 'GRAD' 0, 'opsz' 24
  - preferred icons: `drone_2`, `key`, `upload`, `refresh`, `filter_alt`, `compare_arrows`
- The user interface shall use the reference figma project `DLSE UI` at https://www.figma.com/design/889t8h0409KmMcAbd7ADur/DLSE-UI?t=F4ovEyqYbDApmbM9-0 as a design reference. I also put two screenshots of it inside the `ui` folder named `Start.png` and `MainScreen.png`. It contains the starting page `Start` where only the "Direct Standalone" button shall be implemented for now. Clicking this button will change the UI to the `MainScreen`
- The design guide for colors and buttons is inside the figma make project `Drone Swarm UI Design Guide` at https://www.figma.com/make/GGjtL98SUnvGo4eEWUIiAD/Drone-Swarm-UI-Design-Guide?p=f&t=aOvzabvX2mUJwJfF-0 - I also added some exported resources of that to `\ui\design_guide`

## Implementation
- If you require any additional libraries other than the ones listed in the requirements.txt file, please add them to the requirements.txt file after the existing libraries and after a comment explaining these libraries are required for the UI.
- All user interface related code shall be placed in the `ui` folder. This includes the user interface definition files as well as helper scripts, helper classes or data structures that are only necessary for the user interface. The main library `DroneBridgeCommercialSupportSuite.py` shall only contain functions that are used for CLI and GUI based tasks and shall not contain UI specific features.
- The functions inside the main library `DroneBridgeCommercialSupportSuite.py` shall remain backwards compatible since users may have used them in their custom scripts. We do not want to break those scripts. If necessary create a new function with a different signature or adapt the existing function without chaning the expected behavior or signature for existing scripts.
- Log your progress on the implementation status inside a `progress.md` file. It shall list all features or requirements and give an up to date status on their implementation (done or not)
