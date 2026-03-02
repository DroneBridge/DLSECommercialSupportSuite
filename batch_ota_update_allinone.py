# MIT License
# Copyright (c) 2026 Wolfgang Christl & foremost systems UG (haftungsbeschränkt)
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

from DroneBridgeCommercialSupportSuite import DBLogger, db_scan_for_esp32_devices, db_api_ota_perform_www_update, \
    db_api_ota_perform_app_update_with_progress, db_check_release_binaries_present, db_get_bin_folder
from batch_install_dlse_allinone import play_sound

TARGET_VERSION = "0.0.0-dev.1" # "1.0.0-beta.4" # Only devices with this firmware will be affected. Set to "None" to target any detected device
# Path to the DLSE release root directory -> Download & extract them from https://drone-bridge.com/dlse/
DLSE_RELEASE_PATH = "DroneBridge_ESP32DLSE_BETA4"
LOG_DIR = "logs"

def main():
    global DLSE_RELEASE_PATH, LOG_DIR
    # Parse command line arguments. These will overwrite the config above if set.
    parser = argparse.ArgumentParser(description='Install DroneBridge DLSE on ESP32.')
    parser.add_argument('--release-folder', required=False, type=str,
                        help='Folder path to the root directory of the release e.g. /DroneBridge_ESP32DLSE_BETA3 . Download & extract them from https://drone-bridge.com/dlse/')
    args = parser.parse_args()

    if args.release_folder:
        DLSE_RELEASE_PATH = args.release_folder

    # Initialize the singleton logger
    logger = DBLogger()
    logger.create_log_file("logs", log_file_prefix="dlse_ota_log")

    logger.log(f"Using release folder: {DLSE_RELEASE_PATH}")
    # Check if the DroneBridge binaries are present
    if not db_check_release_binaries_present(DLSE_RELEASE_PATH):
        logger.log("  ❌ Required DroneBridge release binaries are missing!")
        logger.log("  Please download and extract the latest release from https://drone-bridge.com/dlse/")
        logger.log(f"  Expected release path: {DLSE_RELEASE_PATH}")
        beep_failure()
        return

    logger.log("Starting OTA update of all ESP32 devices in the local network")
    logger.log("*** TURN OFF SKYBRUSH LIVE to free up the broadcast port ***")

    # Scan IP address range 192.168.1.0 to 192.168.1.255 for ESP32 devices
    # esp32_broadcast_port is the port we send the broadcast to -> Check the DLSE configuration
    # local_brcst_port is the port we listen for the response from the ESP32 -> Check the DLSE configuration
    detected_devices = db_scan_for_esp32_devices(subnet_mask='192.168.1.0/24', timeout=3, esp32_broadcast_port=14555,
                                                 local_brcst_port=14550)
    if len(detected_devices) == 0:
        logger.log("No DLSE devices found in the local network!")
        beep_failure()
        return
    else:
        for _device in detected_devices:
            selected_device = "[X]"
            if TARGET_VERSION is not None and _device['flight_sw_version']['version_str'] != TARGET_VERSION:
                selected_device = "[ ]"
            logger.log(f"\t{selected_device} IP {_device['ip']} - firmware Version {_device['flight_sw_version']['version_str']}")

    # Ask user if he wants to continue with the update
    user_input = input(
        f"\nDo you want to proceed with the OTA update for the selected [x] devices? (y/n): ")
    if user_input.lower() not in ['y', 'yes']:
        logger.log("OTA update cancelled by user.")
        return

    for esp32_dlse_device in detected_devices:
        if TARGET_VERSION is not None and esp32_dlse_device['flight_sw_version']['version_str'] != TARGET_VERSION:
            logger.log(f"Skipping device {esp32_dlse_device['ip']} as it is not running the required version {TARGET_VERSION}")
            continue
        logger.log(f"Updating device {esp32_dlse_device['ip']}")

        firmware_folder = db_get_bin_folder(chip_id)

        path_www_file = os.path.join(DLSE_RELEASE_PATH, firmware_folder, "www.bin")
        path_app_file = os.path.join(DLSE_RELEASE_PATH, firmware_folder, "db_esp32.bin")
        url_esp32 = f"http://{esp32_dlse_device['ip']}/"
        # Update the web-interface first since it will not reboot - give it the path to the www.bin
        if not db_api_ota_perform_www_update(url_esp32, path_www_file):
            beep_failure()
            logger.log(f"Could not update web-interface of device {esp32_dlse_device['ip']}")
            continue
        # Give it some time to process the change
        time.sleep(2)
        # Update the application - give it the path to the db_esp32.bin -> This will trigger a reboot of the ESP32
        if db_api_ota_perform_app_update_with_progress(url_esp32, path_app_file):
            beep_success()
        else:
            beep_failure()
            logger.log(f"Could not update application of device {esp32_dlse_device['ip']}")
            continue

def beep_success():
    play_sound("resources/new-notification-011-364050.wav")

def beep_failure():
    play_sound("resources/system-notification-04-206493.wav")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n👋 Exiting auto-flash tool.")