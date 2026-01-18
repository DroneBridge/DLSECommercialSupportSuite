# DLSECommercialSupportSuite

Drone Light Show Edition Support Suite for DroneBridge for ESP32.

This suite provides tools and scripts to manage, configure, and license DroneBridge for ESP32 devices, specifically for the Drone Light Show Edition (DLSE).

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

### Key Scripts

*   **`DroneBridgeCommercialSupportSuite.py`**: The main library file containing helper functions.
*   **`example_esp32_dlse_allinone_install.py`**: A comprehensive script that derives the activation key, requests a license, embeds it into settings, generates a partition binary, and flashes the firmware. **Update `MY_SECRET_TOKEN` and `ESP_SERIAL_PORT` before running.**
*   **`example_esp32_get_license.py`**: Standalone script to request a license file using an activation key.
*   **`example_params_update_flash.py`**: Demonstrates how to update configuration parameters (like IP and Hostname) in the CSV and flash them.
*   **`example_esp32_ota_update.py`**: Performs an Over-The-Air (OTA) firmware update for a range of IP addresses.
*   **`example_esp32_download_log.py`** & **`example_esp32_download_log_MAVSDK.py`**: Examples for downloading logs from the flight controller via the ESP32 bridge.

### Example
Example for a fully automated activation and installation of DLSE on a ESP32 connected to COM22, including a pre-defined configuration:
```bash
python example_esp32_dlse_allinone_install.py --token <YOUR_SECRET_TOKEN> --release_folder "DroneBridge_ESP32DLSE_BETA3/esp32c5_generic" --settings_file "DroneBridge_ESP32DLSE_BETA3/db_show_params.csv" --port COM22
```

### Full All-In-One Installation Manual

This is the inital working script. The toolchain will be improved to further simplify the process of flashing a fleet of drones with DroneBridge

1. Manually setup an initial ESP32 with a working config for your show drone
   1. Use e.g. the [online flashing tool](https://drone-bridge.com/flasher/) to install DLSE to your ESP32
   2. Power-cycle the ESP32 and connect to the access point it created "DroneBridge for ESP32" using the default password "dronebridge"
   3. In your browser navigate to the web interface by going to [192.168.2.1](http://192.168.2.1)
   4. Configure the ESP32 according to your needs and test it with your show drone
   5. Manually activate it using the activation key from the bottom of the ESP32s webpage and your secret token from [drone-bridge.com](https://drone-bridge.com) to generate a license file using the [online generator](https://drone-bridge.com/licensegenerator/)
   6. Upload the license via the ESP32 web interface using "Manage License"
   7. Export the settings using the ESP32 web interface
2. Setup the DLSE Commercial Support Toolchain
   1. Go to an appropriate folder on your computer and run
      ```bash
      git clone --recursive https://github.com/DroneBridge/DLSECommercialSupportSuite.git
      cd DLSECommercialSupportSuite
      pip install .
      ```
   2. [Download the latest DLSE release binaries](https://drone-bridge.com/dlse/) and extract them to the `DLSECommercialSupportSuite` folder     
3. From now on it is automated, and you can automatically apply the configuration to all your ESP32s.   
   __Tipp:__ To automatically increase the number of the hostname and static IP by one with every run of the script: Uncomment the line 82 `# db_csv_update_parameters(PATH_SETTINGS_CSV)` inside `example_esp32_dlse_allinone_install.py`   
   __BEWARE:__ In case you are not flashing BETA3 to a ESP32-C5 you need to change the `address_binary_map` at the bottom of the `example_esp32_dlse_allinone_install.py` script.
   Then inside `DLSECommercialSupportSuite` folder run:
   ```bash
   python example_esp32_dlse_allinone_install.py --token <YOUR_SECRET_TOKEN> --release_folder "DroneBridge_ESP32DLSE_BETA3/esp32c5_generic" --settings_file "DroneBridge_ESP32DLSE_BETA3/db_show_params.csv" --port COM22
   ```
   Where the `--settings_file` points to the file you exported from the ESP32 web interface during initial setup.    
   Where the `--release_folder` points to the folder with the DLSE binaries you downloaded   
   The `--port` must be updated with every run to match the serial port of the connected ESP32

The script above will:
*   Automatically request, register with your account and download a license with the license server of DroneBridge
*   Flash the DLSE raw firmware together with your specified settings and license

Running the script multiple times requesting a license with the same activation key (ESP32 ID) will not result in the loss of multiple credits. Re-generation of a license is free of course.

## License

MIT License
