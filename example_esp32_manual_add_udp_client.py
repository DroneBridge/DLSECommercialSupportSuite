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
from DroneBridgeCommercialSupportSuite import db_api_add_custom_udp

# Example script to add a new UDP client manually to the DroneBridge configuration using the web API
URL_ESP32 = "http://192.168.10.66/" # IP address of the ESP32 under which it is reachable
UDP_CLIENT_TARGET_IP = "192.168.10.22" # IP to send UDP packets to from ESP32
UDP_CLIENT_TARGET_PORT = 15540 # PORT to send UDP packets to from ESP32

if db_api_add_custom_udp(URL_ESP32, UDP_CLIENT_TARGET_IP, UDP_CLIENT_TARGET_PORT, _save_udp_to_nvm=True):
    print("Successfully added new UDP client")
else:
    print("Failed to add new UDP client")