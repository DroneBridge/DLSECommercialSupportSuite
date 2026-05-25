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
  - All features not covered by the intermediate goals shall be ignored for now.

## Features
- The user interface should be simple and intuitive.
- The user interface should support all functionality of the Commercial Support Suite. Specifically, the user interface should support the following:
  - Detection of all online ESP32s in the local network based on the IP address range that can be specified by the user, the application shall then scan each IP address in the range and send a http request to the ESP32s to check if they are online.
  - Detection of all online ESP32s in the local network based on the MAVLink response received from the ESP32s, when sending a broadcast MAVLink message.
  - Display of the online ESP32s in the local network. The display shall be updated automatically. The user shall be able to toggle the display between list and matrix/table view.
  - Update of the online ESP32s in the local network every 5 seconds. Do not flood the network with requests since it might overload the network. Consider a rolling update rate.
- The user interface should support the following features:
  - The user shall be able to change the IP address range that is scanned for ESP32s.
  - The user shall be able to filter and search the displayed ESP32s by their name, IP address, MAC, Activation Key, Hostname, basically any data field that is received from the ESP32s via REST:API `/api/system/info`, `/api/settings` or `/api/system/stats`
  - The user shall be able to change the update rate of the displayed ESP32s.
  - The user interface shall support the over the air update of the ESP32s respecting the flows of the `batch_ota_update_allinone.py`.
  - The user interface shall support the activation of the ESP32s using the license server (support for evaluation and regular licenses). Allow the user to choose which license to pick and respecting `batch_ota_license_activation.py`
  - The status of the activation and over the air update shall be displayed per ESP32 in the user interface.
  - When selecting an ESP32 in the user interface, the user shall be able to see the detailed information of the ESP32 including the information from the REST:API `/api/system/info` and `/api/settings`.
  - The user interface may store and update a local copy of the ESP32s parameters. Like a local data model if it makes sense from an architectural point of view.
  - Possibility to update selected or all detected devices firmware OTA (provide inputs based on OTAs function signagure/parameters). The progress of the OTA update shall be visible in the UI in the form of a progress indicator in the detected device table. The user can choose to manually provide a custom image (www.bin & dlse_esp32.bin) or download/choose a default DLSE image that was downloaded from the server automatically.
  - It shall be possible to update multiple devices OTA at once (configuration parameter defaults to 20)
  - Option to download the configuration as a .csv file from the selected devices (right click context menu)
  - Option to upload the configuration as a .csv file to the selected or all detected devices. Option to provide the .csv file from disk using a file chooser.
  - Button for manual scan trigger
  - Inside the table the user can choose what columns shall be visible. By default the columns for the parameter: Hostname, IP, Activation Status, Firmware version, DroneBridge version, MAVLink Sys ID, WiFi SSID, WiFi Channel, RSSI
  - The user interface shall display the license server connection status (Online/Offline). The status shall be updated every 5s.
  - There shall be the option to provide the user token for the DLSE license server via an environment variable named "DRONEBRIDGE_SECRET_TOKEN"
- User interface can be extended with additional features in the future.

## User Interface Framework
- Use PySide6

## Design Language

- The user interface shall use material icons from google fonts: https://github.com/google/material-design-icons/tree/master/png - outlined with weight of 200 and no fill. Alternatively the symbols are available offline as `.ttf` files: `\ui\resources\Material_Symbols_Outlined`
  - material-symbols-outlined: font-variation-settings: 'FILL' 0, 'wght' 200, 'GRAD' 0, 'opsz' 24
  - preferred icons: `drone_2`, `key`, `upload`, `refresh`, `filter_alt`, `compare_arrows` for a connection status
- The user interface shall use the reference image file as a design reference `ui/resources/Master/DBUIConceptSupportSuite.png`
- On the top and below the logo there shall be a navigation bar with the following items:
  - Scan for devices
  - Filter
  - Settings
- The user interface shall be designed for dark mode.
- In the bottom of the UI there shall be a footer with the version of the Commercial Support Suite, the connection status of the DroneBridge license server and the detected ESP32s.
- There are already some image resources available for the UI including the logo: `\ui\resources\images`
- Background color for app: #081c30 or similar for the dark mode and for branding purposes
- Background color for containers and tables: #1a1a1a or similar for the dark mode
- Highlight color: #ffa500
- Font family: Arial
- Font color: #ffffff and #e8e8e8
- Headings in bold
- Text in regular
- Border color: #e7e7e7
- Border radius: 5px
- Border width: 1px
- Coherent design language
- Professional look and feel

## Implementation
- If you require any additional libraries other than the ones listed in the requirements.txt file, please add them to the requirements.txt file after the existing libraries and after a comment explaining these libraries are required for the UI.