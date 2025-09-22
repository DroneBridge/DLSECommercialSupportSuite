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


import time
from DroneBridgeCommercialSupportSuite import db_api_ota_perform_www_update, db_api_ota_perform_app_update_with_progress

# Script calls to update the firmware over the air (OTA) - Settings remain unchanged after OTA update
PATH_WWW_FILE = r"www.bin"
PATH_APP_FILE = r"db_esp32.bin"

# Iterate over IPs to update all ESP32s - make sure all IPs in range are actually valid
# Alternative: Provide a list with valid URLs to the ESP32s and iterate over that list
for last_octet in range(1, 255):
    URL_ESP32 = f"http://192.168.10.{last_octet}/"
    # Update the web-interface first since it will not reboot - give it the path to the www.bin
    db_api_ota_perform_www_update(URL_ESP32, PATH_WWW_FILE)
    # Give it some time to process the change
    time.sleep(2)
    # Update the application - give it the path to the db_esp32.bin -> This will trigger a reboot of the ESP32
    db_api_ota_perform_app_update_with_progress(URL_ESP32, PATH_APP_FILE)

print("Done updating all ESP32s")