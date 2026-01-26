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
import csv
import os
import platform
import shutil
import time
from pathlib import Path

import serial.tools.list_ports

from DroneBridgeCommercialSupportSuite import db_get_activation_key, db_api_request_license_file, DBLicenseType, \
    db_embed_license_in_settings_csv, db_parameters_generate_binary, db_flash_binaries, db_csv_update_parameters, \
    db_get_esp32_chip_id, DLSESupportedChips, db_create_address_binary_map, db_get_dlse_lic_via_serial, \
    db_is_dlse_lic_server_available, db_csv_merge_user_parameters_with_release, DBLogger, \
    db_get_dlse_lic_from_local_storage, DLSE_LICENSE_FOLDER, db_check_release_binaries_present

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
START_DEVICE_ID = 18  # Starting ID for iterating over static IP, hostname index and ap_name with every flashing operation


def main():
    global MY_SECRET_TOKEN, ESP_SERIAL_PORT_FLASH_BAUD_RATE, PATH_SETTINGS_CSV, DLSE_RELEASE_PATH, LOG_DIR, START_DEVICE_ID
    # Parse command line arguments. These will overwrite the config above if set.
    parser = argparse.ArgumentParser(description='Install DroneBridge DLSE on ESP32.')
    parser.add_argument('--release-folder', required=False, type=str,
                        help='Folder path to the root directory of the release e.g. /DroneBridge_ESP32DLSE_BETA3 . Download & extract them from https://drone-bridge.com/dlse/')
    parser.add_argument('--settings-file', required=False, type=str,
                        help='.csv file containing all the settings you want the ESP32 to be configured to. You get it from the DLSE web interface, that way you are flashing a working config to all boards')
    parser.add_argument('--token', required=False, type=str,
                        help='Secret token to authenticate you with the DroneBridge licensing server')
    parser.add_argument('--start-index', required=False, type=int,
                        help='Starting ID for iterating over static IP, hostname index and ap_name with every flashing operation. First ESP32 will get static IP X.X.X.<start_index>, the second ESP32 will get X.X.X.<start_index + 1>')
    parser.add_argument('--baud', required=False, type=int,
                        help="Baud rate used for flashing ESP32. Lower to 115200 if flashing fails")
    args = parser.parse_args()

    if args.token:
        MY_SECRET_TOKEN = args.token
    if args.release_folder:
        DLSE_RELEASE_PATH = args.release_folder
    if args.settings_file:
        PATH_SETTINGS_CSV = args.settings_file
    if args.start_index:
        START_DEVICE_ID = args.start_index
    if args.baud:
        ESP_SERIAL_PORT_FLASH_BAUD_RATE = args.baud

    # Initialize the singleton logger
    logger = DBLogger()
    logger.create_log_file("logs", log_file_prefix="dlse_flashing_log")

    # Show the user what kind of settings and release config he chose
    logger.log(f"Using Token: {MY_SECRET_TOKEN[:4]}...{MY_SECRET_TOKEN[-4:]}")
    logger.log(f"Using settings file: {PATH_SETTINGS_CSV}")
    if not os.path.exists(PATH_SETTINGS_CSV):
        logger.log(f"  ❌ Could not find {PATH_SETTINGS_CSV}")
        beep_failure()
        return
    else:
        logger.log(f"  ✅ Found {PATH_SETTINGS_CSV}")
    logger.log(f"Using release folder: {DLSE_RELEASE_PATH}")
    # Check if the DroneBridge binaries are present
    if not db_check_release_binaries_present(DLSE_RELEASE_PATH):
        logger.log("  ❌ Required DroneBridge release binaries are missing!")
        logger.log("  Please download and extract the latest release from https://drone-bridge.com/dlse/")
        logger.log(f"  Expected release path: {DLSE_RELEASE_PATH}")
        beep_failure()
        return
    logger.log(f"Starting index for setting static IP and hostname: {START_DEVICE_ID}")

    # Merge user parameters with release parameters -> creates a new .csv file used by the script
    # --------------
    merged_csv_path = db_csv_merge_user_parameters_with_release(PATH_SETTINGS_CSV, DLSE_RELEASE_PATH)
    if merged_csv_path is None:
        logger.log("❌ Something went wrong with merging user parameters with release parameters.")
        beep_failure()
        return

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

            if _esp_chip_id is not None and _esp_chip_id in [c.value for c in DLSESupportedChips]:
                ESP_SERIAL_PORT = port
                logger.log(f"Valid chip ID {_esp_chip_id} found on {ESP_SERIAL_PORT}. Starting process...")

                # Derive the activation key from the ESP32 that is attached via the serial port
                # --------------
                activation_key = db_get_activation_key(ESP_SERIAL_PORT)
                if activation_key is None:
                    logger.log("❌ Failed to get activation key. Please check the logs for more information.")
                    beep_failure()
                    continue
                else:
                    logger.log(f"Derived activation key: {activation_key}")

                _dlse_lic_server_available = db_is_dlse_lic_server_available()

                _license_file_path = None
                if not _dlse_lic_server_available:
                    # If we already have the license offline in the DLSE_LICENSE_FOLDER we can get it from there.
                    _license_file_path = db_get_dlse_lic_from_local_storage(activation_key)
                    if _license_file_path is None:
                        # Try to read the license file from the esp via the serial port and store it locally for later
                        logger.log("  No fitting license file found locally. Trying to read the license from the ESP32 via serial...")
                        _license_file_path = db_get_dlse_lic_via_serial(ESP_SERIAL_PORT)
                        if _license_file_path is None:
                            logger.log(
                                "❌ Something went wrong with reading the license file from the ESP32. ABORTING flashing sequence to prevent loss of potentially activated ESP32")
                            beep_failure()
                            # We cannot continue flashing the new settings since we would lose the license and the esp32 ends up in trial mode
                            continue
                        else:
                            # Copy the valid license to the local license storage renaming it to the activation key
                            os.makedirs(DLSE_LICENSE_FOLDER, exist_ok=True)
                            _new_lic_file_path = os.path.join(DLSE_LICENSE_FOLDER, f"{activation_key}.dlselic")
                            shutil.copy2(_license_file_path, _new_lic_file_path)
                            _license_file_path = _new_lic_file_path
                    else:
                        pass # Found a valid license file for {activation_key} in the local license storage. Picking that one.
                else:
                    # Request a license file for the activation key from the DroneBridge licensing server, if activation key was already used, the license will not cost any license credit
                    # --------------
                    # With DBLicenseType.ACTIVATED and validity 0 the license will never expire
                    _license_file_path = db_api_request_license_file(activation_key, MY_SECRET_TOKEN, _license_type=DBLicenseType.ACTIVATED,
                                                               _validity_days=0)
                    if _license_file_path is None:
                        logger.log("❌ Something went wrong with requesting the license file.")
                        beep_failure()
                        continue

                # Adapt your settings file to your needs like changing the ip_sta, wifi_hostname & ap_ssid
                # --------------
                if not db_csv_update_parameters(merged_csv_path, START_DEVICE_ID):
                    logger.log("❌ Something went wrong with updating the IP and hostname configuration in the settings file.")
                    beep_failure()
                    continue

                # ToDo: Add your custom scripts here to change other parameters in the settings by updating merged_csv_path

                # Embed the license within the settings.csv file
                # --------------
                settings_with_lic = db_embed_license_in_settings_csv(merged_csv_path, _license_file_path, create_new_file=True)
                if settings_with_lic is None:
                    logger.log("❌ Something went wrong with integrating the license into the settings file.")
                    beep_failure()
                    continue

                # Create the settings partition binary file that will be flashed to the ESP32
                # --------------
                path_to_settings_partition_bin = db_parameters_generate_binary(settings_with_lic, "0x6000")
                if path_to_settings_partition_bin is None:
                    logger.log("❌ Something went wrong with generating the settings partition from the settings .csv file.")
                    beep_failure()
                    continue

                # Flash the firmware with the settings to the ESP32
                # --------------
                address_binary_map = db_create_address_binary_map(_esp_chip_id, DLSE_RELEASE_PATH, path_to_settings_partition_bin)
                db_flash_binaries(ESP_SERIAL_PORT, address_binary_map, baud_rate=ESP_SERIAL_PORT_FLASH_BAUD_RATE)

                # Read and log the assigned static IP (ip_sta) at the end of the script
                # --------------
                with open(settings_with_lic, 'r', newline='') as f:
                    reader = csv.DictReader(f, quotechar='#')
                    for row in reader:
                        if row.get('key') == 'ip_sta':
                            assigned_ip = row.get('value', '')
                            if assigned_ip:
                                logger.log(f"📍 Assigned static IP: {assigned_ip}")
                            break

                logger.log(f"✅ Finished processing {ESP_SERIAL_PORT}.")
                print('\a')
                START_DEVICE_ID += 1 # Increase the device ID for the next board
                beep_success()
            else:
                logger.log(f"❌ Device on {port} has invalid or unknown chip ID {_esp_chip_id}. Skipping.")
                beep_failure()

def play_sound(file):
    system = platform.system()
    path = Path(file)
    if not path.exists():
        return
    if system == "Windows":
        import winsound
        winsound.PlaySound(str(path), winsound.SND_FILENAME)
    elif system == "Darwin":
        os.system(f"afplay '{path}'")
    else:
        os.system(f"aplay '{path}' >/dev/null 2>&1")

def beep_success():
    play_sound("resources/new-notification-011-364050.wav")

def beep_failure():
    play_sound("resources/system-notification-04-206493.wav")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n👋 Exiting auto-flash tool.")
