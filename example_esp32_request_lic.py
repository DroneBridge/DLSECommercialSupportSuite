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

from DroneBridgeCommercialSupportSuite import db_get_activation_key, db_api_request_license_file, DBLicenseType

MY_SECRET_TOKEN = "<ENTER YOUR TOKEN HERE - GET IT FROM DRONE-BRIDGE.COM WEBSITE>"

activation_key = db_get_activation_key("COM21")
if activation_key is None:
    print("Failed to get activation key. Please check the logs for more information.")
    exit(1)
else:
    print(f"Derived activation key: {activation_key}")

# With DBLicenseType.ACTIVATED and validity 0 the license will never expire
if db_api_request_license_file(activation_key, MY_SECRET_TOKEN, _license_type=DBLicenseType.ACTIVATED, _validity_days=0):
    print("Received License File!")
else:
    print("Something went wrong with requesting the license file. Please check the logs for more information.")