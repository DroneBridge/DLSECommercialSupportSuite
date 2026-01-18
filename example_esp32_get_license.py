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

from DroneBridgeCommercialSupportSuite import db_api_request_license_file, DBLicenseType

# Script to get a license file based on the activation key from the esp32
# License server deducts a license credit for every activation. Re-generation of license keys does not require a license credit


# Secret token to authenticate you with the DroneBridge licensing server
MY_SECRET_TOKEN = "<YOUR KEY FROM THE drone-bridge.com USER INTERFACE>"
activation_key = "<from the ESP32 web interface>"

license_file = db_api_request_license_file(activation_key, MY_SECRET_TOKEN, _license_type=DBLicenseType.ACTIVATED, _validity_days=0)
if license_file is None:
    print("Something went wrong with requesting the license file. Please see logs above for more information.")
    exit(1)