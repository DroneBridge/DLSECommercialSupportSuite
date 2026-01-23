# MIT License
# Copyright (c) 2025 Wolfgang Christl
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
import argparse
import os.path
import time
import serial.tools.list_ports
from datetime import datetime

from DroneBridgeCommercialSupportSuite import db_get_activation_key, db_api_request_license_file, DBLicenseType, \
    db_embed_license_in_settings_csv, db_parameters_generate_binary, db_flash_binaries, db_csv_update_parameters, \
    db_get_esp32_chip_id, DLSESupportedChips, db_create_address_binary_map, db_get_dlse_lic_via_serial, \
    db_is_dlse_lic_server_available, db_merge_user_parameters_with_release, DBLogger

# Secret token to authenticate you with the DroneBridge licensing server
MY_SECRET_TOKEN = "<ENTER YOUR TOKEN HERE - GET IT FROM DRONE-BRIDGE.COM WEBSITE>"
# The serial port of the ESP32
# Flashing baud rate of the ESP32. Lower to 115200 if flashing fails
ESP_SERIAL_PORT_FLASH_BAUD_RATE = 460800
# The path to the settings.csv file that comes with every release you may modify it by adding your own parameter values first
# Recommended: You get it from the DLSE web interface, that way you are flashing a working config to all boards
#                   Go to -> Save/Export Settings in the web interface of your ESP32 running DroneBridge DLSE
PATH_SETTINGS_CSV = "DroneBridge_ESP32DLSE_BETA3/db_show_params.csv"
# Path to the DLSE release root directory -> Download & extract them from https://drone-bridge.com/dlse/
DLSE_RELEASE_PATH = "DroneBridge_ESP32DLSE_BETA3"
LOG_DIR = "logs"



def main():
    global MY_SECRET_TOKEN, ESP_SERIAL_PORT_FLASH_BAUD_RATE, PATH_SETTINGS_CSV, DLSE_RELEASE_PATH, LOG_DIR
    # Parse command line arguments. These will overwrite the config above if set.
    parser = argparse.ArgumentParser(description='Install DroneBridge DLSE on ESP32.')
    parser.add_argument('--release_folder', required=False, type=str,
                        help='Folder path to the root directory of the release e.g. /DroneBridge_ESP32DLSE_BETA3 . Download & extract them from https://drone-bridge.com/dlse/')
    parser.add_argument('--settings_file', required=False, type=str,
                        help='.csv file containing all the settings you want the ESP32 to be configured to. You get it from the DLSE web interface, that way you are flashing a working config to all boards')
    parser.add_argument('--token', required=False, type=str,
                        help='Secret token to authenticate you with the DroneBridge licensing server')

    args = parser.parse_args()

    if args.token:
        MY_SECRET_TOKEN = args.token
    if args.release_folder:
        DLSE_RELEASE_PATH = args.release_folder
    if args.settings_file:
        PATH_SETTINGS_CSV = args.settings_file

    # Initialize the singleton logger
    logger = DBLogger()
    logger.create_log_file("logs", log_file_prefix="dlse_flashing_log")

    # ToDo: Check if the DroneBridge binaries are present and ask the user if he wants to download a release
    #  Get the available releases from the drone-bridge.com server

    logger.log("Monitoring serial ports for new ESP32 devices...")
    known_ports = set([p.device for p in serial.tools.list_ports.comports()])

    while True:
        time.sleep(1.0) # Poll for new devices every second
        current_ports = set([p.device for p in serial.tools.list_ports.comports()])
        new_ports = current_ports - known_ports
        known_ports = current_ports

        for port in new_ports:
            logger.log(f"New device detected on {port}")
            time.sleep(2.0)  # Allow time for device initialization
            _esp_chip_id = db_get_esp32_chip_id(port)

            if _esp_chip_id is not None and _esp_chip_id in DLSESupportedChips:
                ESP_SERIAL_PORT = port
                logger.log(f"Valid chip ID {_esp_chip_id} found on {ESP_SERIAL_PORT}. Starting process...")

                _dlse_lic_server_available = db_is_dlse_lic_server_available()
                _license_file = None
                if not _dlse_lic_server_available:
                    # ToDo: If license server is unavailable, first check if we already have the license offline in the received_licenses folder. Need the activation key for that
                    # otherwise try to read the license file from the esp via the serial port and store it locally for later
                    _license_file = db_get_dlse_lic_via_serial(ESP_SERIAL_PORT)
                    if _license_file is None:
                        logger.log("❌ Something went wrong with reading the license file from the ESP32. Aborting flashing sequence to prevent loss of installed license")
                        # ToDo: Could flash firmware without overwriting the settings in flash -> license remains untouched
                        # We cannot continue flashing the new settings since we would lose the license and the esp32 ends up in trial mode
                        continue
                else:
                    # 1. Derive the activation key from the ESP32 that is attached via the serial port
                    # --------------
                    activation_key = db_get_activation_key(ESP_SERIAL_PORT)
                    if activation_key is None:
                        logger.log("❌ Failed to get activation key. Please check the logs for more information.")
                        continue
                    else:
                        logger.log(f"Derived activation key: {activation_key}")

                    # 2. Request a license file for the activation key from the DroneBridge licensing server, if activation key was already used, the license will not cost any license credit
                    # --------------
                    # With DBLicenseType.ACTIVATED and validity 0 the license will never expire
                    license_file = db_api_request_license_file(activation_key, MY_SECRET_TOKEN, _license_type=DBLicenseType.ACTIVATED,
                                                               _validity_days=0)
                    if license_file is None:
                        logger.log("❌ Something went wrong with requesting the license file.")
                        continue

                # Merge user parameters with release parameters
                # --------------
                merged_csv_path = db_merge_user_parameters_with_release(PATH_SETTINGS_CSV, DLSE_RELEASE_PATH)
                if merged_csv_path is None:
                    logger.log("❌ Something went wrong with merging user parameters with release parameters.")
                    continue

                # Adapt your settings file to your needs like changing the hostname, static IP, wifi SSID and password, etc.
                # --------------
                if not db_csv_update_parameters(merged_csv_path):
                    logger.log("❌ Something went wrong with updating the IP and hostname configuration in the settings file.")
                    continue

                # 3. Embed the license within the settings.csv file
                # --------------
                settings_with_lic = db_embed_license_in_settings_csv(merged_csv_path, license_file, create_new_file=True)
                if settings_with_lic is None:
                    logger.log("❌ Something went wrong with integrating the license into the settings file.")
                    continue

                # 4. Create the settings partition binary file that will be flashed to the ESP32
                # --------------
                path_to_settings_partition_bin = db_parameters_generate_binary(settings_with_lic, "0x6000")
                if path_to_settings_partition_bin is None:
                    logger.log("❌ Something went wrong with generating the settings partition from the settings .csv file.")
                    continue

                # 5. Flash the firmware with the settings to the ESP32
                # --------------
                address_binary_map = db_create_address_binary_map(_esp_chip_id, DLSE_RELEASE_PATH, path_to_settings_partition_bin)
                db_flash_binaries(ESP_SERIAL_PORT, address_binary_map, baud_rate=ESP_SERIAL_PORT_FLASH_BAUD_RATE)
                logger.log(f"✅ Finished processing {ESP_SERIAL_PORT}.")
                print('\a')
            else:
                logger.log(f"❌ Device on {port} has invalid or unknown chip ID {_esp_chip_id}. Skipping.")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n👋 Exiting auto-flash tool.")
