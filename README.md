# DLSECommercialSupportSuite

Drone Light Show Edition Support Suite for DroneBridge for ESP32.

This suite provides tools and scripts to manage, configure, and license DroneBridge for ESP32 devices, specifically for the Drone Light Show Edition (DLSE).

## Prerequisites

*   Python 3.10 or higher
*   A DroneBridge account and license token (for licensing features)

## Installation

1.  Clone the repository:
    ```bash
    git clone https://github.com/DroneBridge/DLSECommercialSupportSuite.git
    cd DLSECommercialSupportSuite
    ```

2.  Install the package and dependencies:
    ```bash
    pip install .
    ```

## Usage

The suite includes several example scripts demonstrating different functionalities. Before running any script, open it and check for configuration variables (like `MY_SECRET_TOKEN`, `ESP_SERIAL_PORT`, or IP addresses) that need to be updated for your environment.

### Key Scripts

*   **`DroneBridgeCommercialSupportSuite.py`**: The main library file containing helper functions.
*   **`example_esp32_dlse_allinone_install.py`**: A comprehensive script that derives the activation key, requests a license, embeds it into settings, generates a partition binary, and flashes the firmware. **Update `MY_SECRET_TOKEN` and `ESP_SERIAL_PORT` before running.**
*   **`example_esp32_get_license.py`**: Standalone script to request a license file using an activation key.
*   **`example_params_update_flash.py`**: Demonstrates how to update configuration parameters (like IP and Hostname) in the CSV and flash them.
*   **`example_esp32_ota_update.py`**: Performs an Over-The-Air (OTA) firmware update for a range of IP addresses.
*   **`example_esp32_download_log.py`** & **`example_esp32_download_log_MAVSDK.py`**: Examples for downloading logs from the flight controller via the ESP32 bridge.

### Running a Script

Example for a fully automated activation and installation of DLSE on a ESP32 connected to COM22, including a pre-defined configuration:
```bash
python example_esp32_dlse_allinone_install.py --token <YOUR_SECRET_TOKEN> --release_folder "DroneBridge_ESP32DLSE_BETA3/esp32c5_generic" --settings_file "DroneBridge_ESP32DLSE_BETA3/db_show_params.csv" --port COM22
```

## License

MIT License
