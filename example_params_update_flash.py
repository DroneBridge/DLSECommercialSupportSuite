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

from DroneBridgeCommercialSupportSuite import db_csv_update_parameters, db_parameters_generate_binary

# Example script to directly flash DroneBridge DLSE configuration parameters via serial (together with the rest of the firmware)
# ------------
# 1. Updates the configuration file by supplying a new IP and hostname directly
# 2. Generates settings partition from the changed .csv
# 3. Flashes the new settings.bin via serial
# --------------------------------------------
# 4. Updates the configuration file by incrementing the IP and hostname by one
# 5. Generates settings partition from the changed .csv
# 6. Flashes the new settings.bin via serial

SETTINGS_CSV_FILE = 'DroneBridge_ESP32DLSE_BETA3/db_show_params.csv'

# Manually set IP and hostname
new_drone_ip = f"192.168.1.99"
new_drone_hostname = f"Drone99"
# Updates a .csv with a different IP and hostname that can be used to generate a settings.bin for flashing settings
# db_csv_update_parameters(SETTINGS_CSV_FILE, new_ip=new_drone_ip, new_hostname=new_drone_hostname)
# SETTINGS_BIN_FILE_PATH = db_parameters_generate_binary(SETTINGS_CSV_FILE)

# Update the .csv file with the new IP and hostname
# Auto increment the IP and hostname by not providing new_ip or new_hostname as parameters (i.e., hostname will be Drone100)
db_csv_update_parameters(SETTINGS_CSV_FILE)
SETTINGS_BIN_FILE_PATH = db_parameters_generate_binary(SETTINGS_CSV_FILE)
