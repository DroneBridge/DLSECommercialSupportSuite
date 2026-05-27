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
import csv
import os
import platform
import shutil
import sys
import time

import serial.tools.list_ports

from dlse_cli_utils import resolve_resource_path, validate_activation_token
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
PATH_SETTINGS_CSV = "DroneBridge_ESP32DLSE_BETA5/db_show_params.csv"
# Path to the DLSE release root directory -> Download & extract them from https://drone-bridge.com/dlse/
DLSE_RELEASE_PATH = "DroneBridge_ESP32DLSE_BETA5"
LOG_DIR = "logs"
START_DEVICE_ID = 18  # Starting ID for iterating over static IP, hostname index and ap_name with every flashing operation
LICENSE_TYPE = DBLicenseType.ACTIVATED
LICENSE_VALIDITY_DAYS = 0

USE_CMD_LINE_ESPTOOL = False # Set to true if you encounter connection issues with the serial port. This maybe more stable.


def mask_token_for_log(token: str | None) -> str:
    """
    Mask the DroneBridge activation token before logging it.

    :param token: Token string from config, environment, or command line.
    :return: Masked token with limited correlation value, or ``<missing>`` when empty.
    """
    if not token:
        return "<missing>"
    if len(token) <= 8:
        return "*" * len(token)
    return f"{token[:4]}...{token[-4:]}"


def parse_args() -> argparse.Namespace:
    """
    Parse command-line arguments for the serial DLSE batch installer.

    :return: Parsed argparse namespace.
    """
    parser = argparse.ArgumentParser(description='Install DroneBridge DLSE on ESP32.')
    parser.add_argument('--release-folder', required=False, type=str,
                        help='Folder path to the root directory of the release e.g. /DroneBridge_ESP32DLSE_BETA3 . Download & extract them from https://drone-bridge.com/dlse/')
    parser.add_argument('--settings-file', required=False, type=str,
                        help='.csv file containing all the settings you want the ESP32 to be configured to. You get it from the DLSE web interface, that way you are flashing a working config to all boards')
    parser.add_argument('--token', required=False, type=str,
                        help='Secret token to authenticate you with the DroneBridge licensing server. Overrides DRONEBRIDGE_SECRET_TOKEN.')
    parser.add_argument('--start-index', required=False, type=int,
                        help='Starting ID for iterating over static IP, hostname index and ap_name with every flashing operation. First ESP32 will get static IP X.X.X.<start_index>, the second ESP32 will get X.X.X.<start_index + 1>')
    parser.add_argument('--baud', required=False, type=int,
                        help="Baud rate used for flashing ESP32. Lower to 115200 if flashing fails")
    parser.add_argument("-e", "--evaluation", action="store_true",
                        help="Request 60-day evaluation licenses instead of activated licenses.")
    return parser.parse_args()


def apply_args(args: argparse.Namespace) -> None:
    """
    Apply command-line and environment overrides to module-level installer settings.

    ``DRONEBRIDGE_SECRET_TOKEN`` overrides the configured default token, and
    ``--token`` overrides both for one-off runs.

    :param args: Parsed command-line arguments.
    :return: None. Updates module-level configuration.
    """
    global MY_SECRET_TOKEN, ESP_SERIAL_PORT_FLASH_BAUD_RATE, PATH_SETTINGS_CSV, DLSE_RELEASE_PATH, LOG_DIR, START_DEVICE_ID, USE_CMD_LINE_ESPTOOL
    global LICENSE_TYPE, LICENSE_VALIDITY_DAYS

    env_token = os.environ.get("DRONEBRIDGE_SECRET_TOKEN")
    if env_token:
        MY_SECRET_TOKEN = env_token
    if args.token:
        MY_SECRET_TOKEN = args.token
    if args.release_folder is not None:
        DLSE_RELEASE_PATH = args.release_folder
    if args.settings_file is not None:
        PATH_SETTINGS_CSV = args.settings_file
    if args.start_index is not None:
        START_DEVICE_ID = args.start_index
    if args.baud is not None:
        ESP_SERIAL_PORT_FLASH_BAUD_RATE = args.baud
    if args.evaluation:
        LICENSE_TYPE = DBLicenseType.EVALUATION
        LICENSE_VALIDITY_DAYS = 60
    else:
        LICENSE_TYPE = DBLicenseType.ACTIVATED
        LICENSE_VALIDITY_DAYS = 0


def acquire_license_file(activation_key: str, serial_port: str, logger: DBLogger) -> str | None:
    """
    Get a license file for one ESP32 according to the selected license mode.

    Activated mode preserves the existing safety fallback: if the license server
    is unavailable, use a matching cached license or read the current license
    from the ESP32 before flashing. Evaluation mode always requires the license
    server because temporary evaluation licenses cannot be recovered offline.

    :param activation_key: Base64 activation key read from the ESP32.
    :param serial_port: Serial port used for optional activated-license recovery.
    :param logger: Logger for operator-facing status messages.
    :return: License file path, or ``None`` when the device must be skipped.
    """
    dlse_lic_server_available = db_is_dlse_lic_server_available()

    if not dlse_lic_server_available:
        if LICENSE_TYPE == DBLicenseType.EVALUATION:
            logger.log("❌ License server unavailable. Evaluation licenses cannot be created offline. Skipping device.")
            return None

        license_file_path = db_get_dlse_lic_from_local_storage(activation_key)
        if license_file_path is not None:
            return license_file_path

        logger.log("  No fitting license file found locally. Trying to read the license from the ESP32 via serial...")
        license_file_path = db_get_dlse_lic_via_serial(
            serial_port,
            ESP_SERIAL_PORT_FLASH_BAUD_RATE,
            _use_cmd_line_tool=USE_CMD_LINE_ESPTOOL,
        )
        if license_file_path is None:
            logger.log(
                "❌ Something went wrong with reading the license file from the ESP32. ABORTING flashing sequence to prevent loss of potentially activated ESP32"
            )
            return None

        os.makedirs(DLSE_LICENSE_FOLDER, exist_ok=True)
        new_lic_file_path = os.path.join(DLSE_LICENSE_FOLDER, f"{activation_key}.dlselic")
        shutil.copy2(license_file_path, new_lic_file_path)
        return new_lic_file_path

    license_file_path = db_api_request_license_file(
        activation_key,
        MY_SECRET_TOKEN,
        _license_type=LICENSE_TYPE,
        _validity_days=LICENSE_VALIDITY_DAYS,
    )
    if license_file_path is None:
        logger.log("❌ Something went wrong with requesting the license file.")
    return license_file_path


def cleanup_evaluation_license_file(license_file_path: str | None, logger: DBLogger) -> None:
    """
    Remove a temporary evaluation license file after it has been embedded.

    :param license_file_path: License file path returned by ``acquire_license_file``.
    :param logger: Logger for non-fatal cleanup failures.
    :return: None.
    """
    if LICENSE_TYPE != DBLicenseType.EVALUATION or not license_file_path:
        return
    try:
        os.remove(license_file_path)
    except OSError as e:
        logger.log(f"Failed to remove temporary evaluation license {license_file_path}: {e}")


def main():
    """
    Run the serial batch flashing, configuration, and license activation workflow.

    The script applies configuration from defaults, ``DRONEBRIDGE_SECRET_TOKEN``,
    and command-line arguments before starting serial-port monitoring. A valid
    activation token must be supplied before release files or serial ports are used.
    """
    global MY_SECRET_TOKEN

    apply_args(parse_args())
    try:
        MY_SECRET_TOKEN = validate_activation_token(MY_SECRET_TOKEN)
    except ValueError as e:
        print(f"Fatal: {e}")
        sys.exit(2)

    # Initialize the singleton logger
    logger = DBLogger()
    logger.create_log_file("logs", log_file_prefix="dlse_flashing_log")

    # Show the user what kind of settings and release config he chose
    logger.log(f"Using Token: {mask_token_for_log(MY_SECRET_TOKEN)}")
    if LICENSE_TYPE == DBLicenseType.EVALUATION:
        logger.log("License mode: EVALUATION, validity: 60 days. Evaluation licenses require license server access and are temporary.")
    else:
        logger.log("License mode: ACTIVATED, validity: permanent. Activated licenses can use offline recovery if needed.")
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
            _esp_chip_id = db_get_esp32_chip_id(port, ESP_SERIAL_PORT_FLASH_BAUD_RATE, _use_cmd_line_tool=USE_CMD_LINE_ESPTOOL)

            if _esp_chip_id is not None and _esp_chip_id in [c.value for c in DLSESupportedChips]:
                ESP_SERIAL_PORT = port
                logger.log(f"Valid chip ID {_esp_chip_id} found on {ESP_SERIAL_PORT}. Starting process...")

                # Derive the activation key from the ESP32 that is attached via the serial port
                # --------------
                activation_key = db_get_activation_key(ESP_SERIAL_PORT, ESP_SERIAL_PORT_FLASH_BAUD_RATE, _use_cmd_line_tool=USE_CMD_LINE_ESPTOOL)
                if activation_key is None:
                    logger.log("❌ Failed to get activation key. Please check the logs for more information.")
                    beep_failure()
                    continue
                else:
                    logger.log(f"Derived activation key: {activation_key}")

                _license_file_path = acquire_license_file(activation_key, ESP_SERIAL_PORT, logger)
                if _license_file_path is None:
                    beep_failure()
                    continue

                # Adapt your settings file to your needs like changing the ip_sta, wifi_hostname & ap_ssid
                # --------------
                if not db_csv_update_parameters(merged_csv_path, START_DEVICE_ID):
                    logger.log("❌ Something went wrong with updating the IP and hostname configuration in the settings file.")
                    beep_failure()
                    continue

                # ToDo: Add your custom scripts here to change other parameters in the settings by updating the .csv file located at merged_csv_path

                # Embed the license within the settings.csv file
                # --------------
                settings_with_lic = db_embed_license_in_settings_csv(merged_csv_path, _license_file_path, create_new_file=True)
                if settings_with_lic is None:
                    logger.log("❌ Something went wrong with integrating the license into the settings file.")
                    beep_failure()
                    continue
                cleanup_evaluation_license_file(_license_file_path, logger)

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
    """
    Play a notification sound when the bundled audio file is available.

    :param file: Source checkout or package-relative path to a wave file.
    :return: None. Missing files and playback errors are ignored by the caller.
    """
    system = platform.system()
    path = resolve_resource_path(file)
    if path is None:
        return
    try:
        if system == "Windows":
            import winsound
            winsound.PlaySound(str(path), winsound.SND_FILENAME)
        elif system == "Darwin":
            os.system(f"afplay '{path}'")
        else:
            os.system(f"aplay '{path}' >/dev/null 2>&1")
    except Exception:
        return

def beep_success():
    """
    Play the best-effort success notification sound.

    :return: None. Missing audio support does not fail the workflow.
    """
    play_sound("resources/new-notification-011-364050.wav")


def beep_failure():
    """
    Play the best-effort failure notification sound.

    :return: None. Missing audio support does not fail the workflow.
    """
    play_sound("resources/system-notification-04-206493.wav")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n👋 Exiting auto-flash tool.")
