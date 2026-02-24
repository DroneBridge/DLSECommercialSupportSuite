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
from DroneBridgeCommercialSupportSuite import db_scan_for_esp32_devices

if __name__ == "__main__":
    # --> TURN OFF SKYBRUSH LIVE

    # Scan IP address range 192.168.1.0 to 192.168.1.255 for ESP32 devices
    detected_devices = db_scan_for_esp32_devices(subnet_mask='192.168.1.0/24', timeout=3, esp32_broadcast_port=14555, local_brcst_port=14550)
    for esp32_dlse_device in detected_devices:
        print(esp32_dlse_device)