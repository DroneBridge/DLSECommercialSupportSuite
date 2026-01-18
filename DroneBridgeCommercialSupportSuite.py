# MIT License
#
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
import base64
import csv
import os
import ipaddress
import struct
import subprocess
import sys

import requests
from urllib.parse import urljoin
from enum import Enum
from esptool import detect_chip
from tqdm import tqdm

class DBLicenseType(Enum):
    TRIAL = 0
    EVALUATION = 1
    ACTIVATED = 2
    EXPIRED = 3

def db_get_activation_key(_serial_port: str) -> str | None:
    """Connects to the ESP32 and calculates the activation key. Returns None if an error occurs."""
    activation_key = None
    esp = None
    try:
        # Connect to the ESP32
        # defaults: initial_baud=460800, trace_enabled=False, connect_mode='default_reset'
        esp = detect_chip(_serial_port)
        print(f"Connecting to {_serial_port}...")

        # Read MAC Address
        mac = esp.read_mac()
        mac_str = ':'.join(map(lambda x: '{:02x}'.format(x), mac))
        print(f"MAC Address: {mac_str}")

        # Calculate Activation Key
        try:
            # Determine Chip ID (integer)
            chip_id = esp.get_chip_id()
            # Chip Revision
            chip_rev = esp.get_chip_revision()

            # Read Chip ID (Type)
            chip_type = esp.get_chip_description()
            print(f"Chip Type: {chip_type} ID: {chip_id} Rev: {chip_rev}")

            # Use little-endian (<)
            # Ensure mac is bytes
            mac_bytes = bytes(mac)
            packed_data = struct.pack('<6sBH', mac_bytes, chip_id, chip_rev)

            activation_key = base64.b64encode(packed_data).decode('utf-8')

        except Exception as e:
            print(f"Error calculating activation key: {e}")

    except Exception as e:
        print(f"Error: {e}")
    finally:
        if esp is not None:
            esp._port.close()

    return activation_key


def db_embed_license_in_settings_csv(_settings_csv_file_path: str, _license_file_path: str,
                                     create_new_file=False) -> str | None:
    """
    Appends or updates the content of the license file in the settings CSV file.
    The license content is base64 encoded and added as a binary entry.
    Entry format: db_lic_key,data,base64,<BASE64_LICENSE_CONTENT>
    Ensures 'license,namespace,,' header exists if adding new key.
    """
    if not os.path.exists(_settings_csv_file_path):
        print(f"❌ Error: The file '{_settings_csv_file_path}' was not found.")
        return None

    if not os.path.exists(_license_file_path):
        print(f"❌ Error: The file '{_license_file_path}' was not found.")
        return None

    try:
        # Read license file content
        with open(_license_file_path, 'rb') as f:
            license_content = f.read()

        # Encode content to base64
        license_b64 = base64.b64encode(license_content).decode('utf-8')

        # Read all existing data
        rows = []
        with open(_settings_csv_file_path, 'r', newline='') as f:
            reader = csv.reader(f)
            rows = list(reader)

        license_namespace_header = ['license', 'namespace', '', '']
        license_key_row = ['db_lic_key', 'data', 'base64', license_b64]

        header_exists = False
        key_index = -1

        # Check for existence
        for i, row in enumerate(rows):
            if len(row) >= 2 and row[0] == 'license' and row[1] == 'namespace':
                header_exists = True
            if len(row) >= 1 and row[0] == 'db_lic_key':
                key_index = i

        if key_index != -1:
            # Update existing key
            rows[key_index] = license_key_row
            print(f"Updated existing license key.")
        else:
            # Key does not exist
            if not header_exists:
                rows.append(license_namespace_header)
            rows.append(license_key_row)
            print(f"Appended license key.")

        # Determine output file path
        output_file_path = _settings_csv_file_path
        if create_new_file:
            base, ext = os.path.splitext(_settings_csv_file_path)
            output_file_path = f"{base}_lic_added{ext}"
            print(f"Creating new settings file: '{output_file_path}'")
        else:
            print(f"Updating existing settings file: '{output_file_path}'")

        # Write back to CSV file
        with open(output_file_path, 'w', newline='') as f:
            writer = csv.writer(f)
            writer.writerows(rows)

        print(f"✅ Created combined license and settings file: '{output_file_path}'")
        return output_file_path

    except Exception as e:
        print(f"❌ Error updating '{_settings_csv_file_path}': {e}")
        return False

    except Exception as e:
        print(f"❌ Error updating '{_settings_csv_file_path}': {e}")
        return False


def db_api_request_license_file(_activation_key: str, _token: str, _output_path="received_licenses/",
                                _license_type=DBLicenseType.ACTIVATED, _validity_days=0,
                                base_url="https://drone-bridge.com/api/license/generate") -> str | None:
    """
    Requests the license file from the licensing server.
    """
    params = {
        "activationKey": _activation_key,
        "licenseType": _license_type.value,
        "validityDays": str(_validity_days),
    }
    headers = {
        "Authorization": f"Bearer {_token}"
    }

    try:
        print(f"Requesting license from {base_url}...")
        response = requests.get(base_url, params=params, headers=headers, stream=True)

        if response.status_code == 200:
            # Try to get filename from header if available, else use default
            filename = f"{_activation_key}.dlselic"
            if "Content-Disposition" in response.headers:
                cd = response.headers["Content-Disposition"]
                if "filename=" in cd:
                    filename = cd.split("filename=")[1].strip('"').strip()

            if _output_path:
                os.makedirs(_output_path, exist_ok=True)
            filename = os.path.join(_output_path, filename)
            with open(filename, 'wb') as f:
                for chunk in response.iter_content(chunk_size=8192):
                    f.write(chunk)
            print(f"✅ License generated and saved to '{filename}'")
            return filename
        else:
            print(f"❌ Failed to generate license. Status Code: {response.status_code}")
            print(f"Response: {response.text}")
            return None
    except Exception as e:
        print(f"❌ Error: {e}")
        return None

def db_parameters_generate_binary(_path_to_settings_csv: str, partition_size="0x6000") -> str | None:
    """
    Generates a NVS binary partition from the settings CSV file using the esp-idf-nvs-partition-gen tool.
    Returns the path to the generated .bin file or None if failed.
    """
    script_dir = os.path.dirname(os.path.abspath(__file__))
    nvs_tool_path = os.path.join(script_dir, "esp-idf-nvs-partition-gen", "esp_idf_nvs_partition_gen", "nvs_partition_gen.py")

    if not os.path.exists(nvs_tool_path):
        print(f"❌ Error: NVS partition generator tool not found at '{nvs_tool_path}'")
        return None

    if not os.path.exists(_path_to_settings_csv):
        print(f"❌ Error: Input CSV file '{_path_to_settings_csv}' not found")
        return None

    output_bin = os.path.splitext(_path_to_settings_csv)[0] + ".bin"

    cmd = [
        sys.executable,
        nvs_tool_path,
        "generate",
        _path_to_settings_csv,
        output_bin,
        partition_size
    ]

    print(f"Generating binary from '{_path_to_settings_csv}'...")
    try:
        # Run the script and capture output
        result = subprocess.run(cmd, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        print(result.stdout)
        print(f"✅ Successfully created '{output_bin}'")
        return output_bin
    except subprocess.CalledProcessError as e:
        print(f"❌ Error generating binary: {e}")
        print("STDOUT:", e.stdout)
        print("STDERR:", e.stderr)
        return None
    except Exception as e:
        print(f"❌ Error executing NVS tool: {e}")
        return None

def db_flash_binaries(serial_port: str, address_binary_map: dict, baud_rate=460800) -> bool:
    """
    Flashes binaries to the ESP32 using esptool.
    :param serial_port: Serial port of the ESP32 (e.g. COM3 or /dev/ttyUSB0)
    :param address_binary_map: Dictionary mapping address (int or hex string) to file path
                               Example: {0x1000: 'bootloader.bin', "0x9000": 'partition-table.bin'}
    :param baud_rate: Baud rate for flashing (default 460800)
    :return: True if successful, False otherwise
    """
    if not address_binary_map:
        print("Error: No binaries provided for flashing.")
        return False

    # Verify files exist
    for addr, path in address_binary_map.items():
        if not os.path.exists(path):
            print(f"Error: File not found '{path}' for address {addr}")
            return False

    cmd = [
        sys.executable, "-m", "esptool",
        "--chip", "auto",
        "--port", serial_port,
        "--baud", str(baud_rate),
        "write-flash",
        "-z"
    ]

    # Add addresses and files
    for address, file_path in address_binary_map.items():
        cmd.append(str(address))
        cmd.append(file_path)

    print(f"Starting flash operation on {serial_port}...")
    try:
        # Using subprocess to isolate esptool execution
        subprocess.run(cmd, check=True)
        print("✅ Flashing completed successfully!")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Flashing failed with error code {e.returncode}")
        return False
    except Exception as e:
        print(f"❌ An error occurred: {e}")
        return False

class FileWithProgress(object):
    """
    Helper class that provides access to a file with progress bars.
    """
    def __init__(self, file_path, callback):
        self._file = open(file_path, 'rb')
        self._callback = callback
        self._total = os.path.getsize(file_path)
        self._sent = 0
        self._tqdm_instance = tqdm(
            total=self._total,
            unit='B',
            unit_scale=True,
            desc='Uploading'
        )

    def __len__(self):
        return self._total

    def read(self, chunk_size):
        chunk = self._file.read(chunk_size)
        self._sent += len(chunk)
        self._tqdm_instance.update(len(chunk))
        return chunk

    def close(self):
        self._file.close()
        self._tqdm_instance.close()

    # --- Context Manager Protocol ---
    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.close()


def progress_callback(sent, total):
    """This function updates the progress bar"""
    if not hasattr(progress_callback, 'tqdm_instance'):
        progress_callback.tqdm_instance = tqdm(total=total, unit='B', unit_scale=True, desc='Uploading')

    progress_callback.tqdm_instance.update(sent - progress_callback.tqdm_instance.n)


def upload_binary_file_with_progress(file_path, url):
    """
    Loads a binary file and posts it to a URL with a progress bar.
    """
    try:
        with FileWithProgress(file_path, None) as data: # The callback is now handled internally
            response = requests.post(url, data=data)
            response.raise_for_status()
            return response
    except Exception as e:
        print(f"\n❌ Upload failed: {e}")
        raise


def validate_ip(ip_string: str) -> bool:
    """
    Validates an IP address (both IPv4 and IPv6).
    Returns True if the IP is valid, False otherwise.
    """
    try:
        ipaddress.ip_address(ip_string)
        return True
    except ValueError:
        return False


def db_csv_update_parameters(_csv_settings_file_path: str, new_ip=None, new_hostname=None):
    """
    Reads the CSV, increments the IP and hostname by one if no new_ip or new_hostname are given
    Else it takes the new_ip or new_hostname.
    Saves the file.
    Updated .csv file can be used to generate a new settings.bin (partition) that can be flashed via serial.
    """
    if not os.path.exists(_csv_settings_file_path):
        print(f"Error: The file '{_csv_settings_file_path}' was not found.")
        return

    # Read the data from the CSV file
    try:
        with open(_csv_settings_file_path, 'r', newline='') as f:
            # Using DictReader to easily access columns by key name
            reader = csv.DictReader(f)
            data = list(reader)
            # Store the header separately to write it back later
            header = reader.fieldnames
    except Exception as e:
        print(f"Error reading '{_csv_settings_file_path}': {e}")
        return

    new_ip_octet = None
    original_hostname = None

    # Find and update the IP address and hostname in the data
    for row in data:
        if row['key'] == 'ip_sta':
            if new_ip_octet is None:
                # Increment IP by one
                try:
                    ip_parts = row['value'].split('.')
                    last_octet = int(ip_parts[-1])
                    new_last_octet = last_octet + 1
                    ip_parts[-1] = str(new_last_octet)
                    row['value'] = '.'.join(ip_parts)
                    new_ip_octet = new_last_octet
                    print(f"Updated ip_sta to: {row['value']}")
                except (ValueError, IndexError) as e:
                    print(f"Could not parse IP address '{row['value']}': {e}")
                    return # Stop execution if IP is invalid
            elif validate_ip(new_ip):
                # Use given IP
                row['value'] = new_ip
                ip_parts = row['value'].split('.')
                new_ip_octet = int(ip_parts[-1])
            else:
                print(f"Given IP address '{new_ip}' is invalid. Skipping change of IP address.")
                return

        if row['key'] == 'wifi_hostname':
            # Store the original hostname to modify it after finding the new IP octet
            original_hostname = row['value']


    # Update the hostname using the new IP octet
    for row in data:
        if row['key'] == 'wifi_hostname':
            if new_hostname is None:
                if new_ip_octet is not None and original_hostname is not None:
                    # This logic assumes the base hostname doesn't end in numbers.
                    # A more robust way would be to strip old numbers if they exist.
                    base_hostname = ''.join(filter(str.isalpha, original_hostname))
                    row['value'] = f"{base_hostname}{new_ip_octet}"
                    print(f"Updated wifi_hostname to: {row['value']}")
                    break # Stop after updating
                else:
                    print("Error setting wifi_hostname. New IP octet not set or original hostname not set.")
            else:
                row['value'] = new_hostname
                print(f"Updated wifi_hostname to: {row['value']}")
                break # Stop after updating

    # Write the modified data back to the CSV file
    try:
        with open(_csv_settings_file_path, 'w', newline='') as f:
            writer = csv.DictWriter(f, fieldnames=header)
            writer.writeheader()
            writer.writerows(data)
        print(f"Successfully saved changes to '{_csv_settings_file_path}'.")
    except Exception as e:
        print(f"Error writing to '{_csv_settings_file_path}': {e}")
        return


def db_api_add_custom_udp(_drone_bridge_url: str, _udp_client_target_ip: str, _udp_client_target_port: int, _save_udp_to_nvm=True) -> bool:
    """
    Will add a custom UDP client to the ESP32 UDP broadcast list. Equals to adding a UDP target via the "+" in the web interface.
    :param _drone_bridge_url: IP address of the ESP32. e.g. "http://192.168.10.4/"
    :param _udp_client_target_ip: IP address UDP target. Where to send the UDP packets to. e.g. "192.168.10.4
    :param _udp_client_target_port Port address UDP target. Where to send the UDP packets to. e.g. 15540
    :param _save_udp_to_nvm: Save to NVM to persist across reboots.
    :return: True if successful, False otherwise.
    """
    target_url = urljoin(_drone_bridge_url, 'api/settings/clients/udp')
    data = {
        "ip": _udp_client_target_ip,
        "port": _udp_client_target_port,
        "save": _save_udp_to_nvm
    }
    # Send the POST request
    response = requests.post(target_url, json=data)

    # Check if the request was successful
    if response.status_code == 200:
        print("Request successful.")
        print(response.content.decode())
        return True
    else:
        print(f"Request failed with status code: {response.status_code}")
        print(response.content.decode())
        return False


def db_api_add_static_ip(_drone_bridge_url: str, _static_ip: str, _static_ip_netmask: str, _static_ip_gateway: str) -> bool:
    """
    Sets a static IP for the ESP32. Only applies in Wi-Fi client mode.

    :param _drone_bridge_url: IP address of the ESP32. e.g. "http://192.168.10.4/"
    :param _static_ip: Static IP to set. e.g. "192.198.10.66"
    :param _static_ip_netmask: Static IP to set. e.g. "255.255.255.0"
    :param _static_ip_gateway: Static IP to set. e.g. "192.198.10.1"
    :return: True in case of success, False otherwise.
    """
    target_url = urljoin(_drone_bridge_url, 'api/settings/static-ip')
    data = {
        "ip_sta": _static_ip,  # static ip
        "ip_sta_netmsk": _static_ip_netmask,   # netmask
        "ip_sta_gw": _static_ip_gateway # gateway ip
    }
    # Send the POST request
    response = requests.post(target_url, json=data)

    # Check if the request was successful
    if response.status_code == 200:
        print("Static IP request successful.")
        print(response.content.decode())
        return True
    else:
        print(f"Static IP request failed with status code: {response.status_code}")
        print(response.content.decode())
        return False



def db_api_reset_static_ip(_drone_bridge_url: str) -> bool:
    """
    Resets the static IP for the ESP32. After the reboot static IP is disabled for the ESP32.
    Only applies in Wi-Fi client mode.

    :param _drone_bridge_url: IP address of the ESP32. e.g. "http://192.168.10.4/"
    :return: True in case of success, False otherwise.
    """
    target_url = urljoin(_drone_bridge_url, 'api/settings/static-ip')
    data = {
        "ip_sta": "",
        "ip_sta_netmsk": "",
        "ip_sta_gw": ""
    }
    # Send the POST request
    response = requests.post(target_url, json=data)

    # Check if the request was successful
    if response.status_code == 200:
        print("Request successful.")
        print(response.content.decode())
        return True
    else:
        print(f"Request failed with status code: {response.status_code}")
        print(response.content.decode())
        return False


def db_api_ota_perform_www_update(_drone_bridge_url, _path_www_file) -> bool:
    """
    Updates the web interface using the www.bin doing an OTA firmware update.

    :param _drone_bridge_url: IP address of the ESP32. e.g. "http://192.168.10.4/"
    :param _path_www_file: File path to www file (.bin) that you want to upload
    :return: True in case of success, False otherwise.
    """
    url = urljoin(_drone_bridge_url, 'update/www')
    try:
        with open(_path_www_file, 'rb') as f:
            file_data = f.read()
    except FileNotFoundError as e:
        print(f"Error: The file '{_path_www_file}' was not found.")
        return False

    # Send the POST request
    response = requests.post(url, data=file_data)

    # Check if the request was successful
    if response.status_code == 200:
        print("Request successful.")
        print(response.content.decode())
        return True
    else:
        print(f"Request failed with status code: {response.status_code}")
        print(response.content.decode())
        return False


def db_api_ota_perform_app_update_with_progress(_drone_bridge_url, _path_app_file) -> bool:
    """
    Upload app file for OTA with progress bar feedback

    :param _drone_bridge_url: URL of the DroneBridge ESP32 e.g. http://192.168.1.2/
    :param _path_app_file: File path to app file (.bin) that you want to upload
    :return: True in case of success, False otherwise.
    """
    target_url = urljoin(_drone_bridge_url, 'update/firmware')

    print(f"Uploading '{_path_app_file}' to '{target_url}' with progress...")
    try:
        response = upload_binary_file_with_progress(_path_app_file, target_url)
        print("\n✅ Upload successful!")
        print(f"Status Code: {response.status_code}\n{response.content.decode()}")
        return True
    except requests.exceptions.RequestException as e:
        print(f"\n❌ Upload failed: {e}")
        return False
