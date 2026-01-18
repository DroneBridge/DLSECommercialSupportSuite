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
import os.path

from DroneBridgeCommercialSupportSuite import db_get_activation_key, db_api_request_license_file, DBLicenseType, \
    db_embed_license_in_settings_csv, db_parameters_generate_binary, db_flash_binaries

# ToDo: Update the parameters below to match your environment and account settings
# Secret token to authenticate you with the DroneBridge licensing server
MY_SECRET_TOKEN = "<ENTER YOUR TOKEN HERE - GET IT FROM DRONE-BRIDGE.COM WEBSITE>"
# The serial port of the ESP32
ESP_SERIAL_PORT = "COM22"
# Flashing baud rate of the ESP32. Lower to 115200 if flashing fails
ESP_SERIAL_PORT_FLASH_BAUD_RATE = 460800
# The path to the settings.csv file that comes with every release you may modify it by adding your own parameter values first
# Recommended: You get it from the DLSE web interface, that way you are flashing a working config to all boards
#                   Go to -> Save/Export Settings in the web interface of your ESP32 running DroneBridge DLSE
PATH_SETTINGS_CSV = "DroneBridge_ESP32DLSE_BETA3/db_show_params.csv"
# Path to the DLSE binaries (www.bin, db_esp32.bin etc.) -> Download & extract them from https://drone-bridge.com/dlse/
DLSE_RELEASE_PATH = "DroneBridge_ESP32DLSE_BETA3/esp32c5_generic"



# 1. Derive the activation key from the ESP32 that is attached via the serial port
# --------------
activation_key = db_get_activation_key(ESP_SERIAL_PORT)
if activation_key is None:
    print("Failed to get activation key. Please check the logs for more information.")
    exit(1)
else:
    print(f"Derived activation key: {activation_key}")

# 2. Request a license for the activation key from the DroneBridge licensing server
# --------------
# With DBLicenseType.ACTIVATED and validity 0 the license will never expire
license_file = db_api_request_license_file(activation_key, MY_SECRET_TOKEN, _license_type=DBLicenseType.ACTIVATED, _validity_days=0)
if license_file is None:
    print("Something went wrong with requesting the license file. Please check the logs for more information.")
    exit(1)

# ToDo: Optional: Adapt your settings file to your needs like changing the hostname, static IP, wifi SSID and password, etc.
# --------------
# You could use e.g. the function db_csv_update_parameters to increment the IP and hostname by one.
# Check the example given in `example_params_update_flash.py`
# db_csv_update_parameters(PATH_SETTINGS_CSV)

# 3. Embed the license within the settings.csv file
# --------------
settings_with_lic = db_embed_license_in_settings_csv(PATH_SETTINGS_CSV, license_file, create_new_file=True)
if settings_with_lic is None:
    print("Something went wrong with integrating the license into the settings file.")
    exit(1)

# 4. Create the settings partition binary file that will be flashed to the ESP32
# --------------
path_to_settings_partition_bin = db_parameters_generate_binary(settings_with_lic, "0x6000")
if path_to_settings_partition_bin is None:
    print("Something went wrong with generating the settings partition from the settings .csv file.")


# 5. Flash the firmware with the settings to the ESP32
# --------------
# ToDo: Generate flashing table based on the addresses inside the flash_args.txt file.
#  THE SETTINGS BELOW ARE FOR ESP32-C5 & the DLSE BETA3 release only!
address_binary_map = {
    0x2000: os.path.join(DLSE_RELEASE_PATH, 'bootloader.bin'),
    0x20000: os.path.join(DLSE_RELEASE_PATH, 'db_esp32.bin'),
    0x8000: os.path.join(DLSE_RELEASE_PATH, 'partition-table.bin'),
    0xf000: os.path.join(DLSE_RELEASE_PATH, 'ota_data_initial.bin'),
    0x3ac000: os.path.join(DLSE_RELEASE_PATH, 'www.bin'),
    0x9000: path_to_settings_partition_bin,
}
db_flash_binaries(ESP_SERIAL_PORT, address_binary_map, baud_rate=ESP_SERIAL_PORT_FLASH_BAUD_RATE)