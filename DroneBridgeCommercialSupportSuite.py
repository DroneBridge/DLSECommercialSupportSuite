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
import tempfile
import requests
from datetime import datetime
from urllib.parse import urljoin
from enum import Enum
from esptool import detect_chip
from tqdm import tqdm
from nvs_partition_tool.nvs_parser import NVS_Partition

DLSE_SETTINGS_PARTITION_ADDRESS = 0x9000
DLSE_SETTINGS_PARTITION_SIZE = 0x6000


class DBLogger:
    """
    Singleton logger class for DroneBridge operations.
    Ensures all logging from both user script and library functions goes to the same log file.
    """
    _instance = None
    _log_file = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance

    def create_log_file(self, log_dir_path: str, log_file_prefix="dlse_flashing_log") -> str:
        """Set the log file path for this logger instance."""
        os.makedirs(log_dir_path, exist_ok=True)
        timestamp_file = datetime.now().strftime("%Y%m%d_%H%M%S")
        self._log_file = os.path.join(log_dir_path, f"{log_file_prefix}_{timestamp_file}.log")
        print(f"Created log file {self._log_file}")
        return self._log_file

    def log(self, message):
        """Log a message with timestamp to console and file."""
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        full_message = f"[{timestamp}] {message}"
        print(full_message)
        if self._log_file is None:
            self.create_log_file("logs")
        if self._log_file:
            try:
                with open(self._log_file, "a") as f:
                    f.write(full_message + "\n")
            except Exception as e:
                print(f"Error writing to log file: {e}")
        else:
            print("Cannot log. No log file created by DBLogger")


class DBLicenseType(Enum):
    TRIAL = 0
    EVALUATION = 1
    ACTIVATED = 2
    EXPIRED = 3

class DLSESupportedChips(Enum):
    ESP32C3 = 5
    ESP32C5 = 23
    ESP32C6 = 13


def db_is_dlse_lic_server_available(lic_server_address="https://drone-bridge.com/api/license/generate") -> bool:
    logger = DBLogger()
    try:
        response = requests.get(lic_server_address, timeout=5)
        if response.status_code < 500:
            return True
        else:
            logger.log(f"❌ License server returned status code: {response.status_code}")
            return False
    except requests.RequestException as e:
        logger.log(f"❌ License server not available: {e}")
        return False

def db_get_bin_folder(_chip_id: int):
    logger = DBLogger()
    # Folder names in the release binaries
    DLSEBinFolderNames = {"C3_folder": "esp32c3_generic", "C5_folder": "esp32c5_generic",
                          "C6_folder": "esp32c6_generic"}
    if _chip_id == 5:
        return DLSEBinFolderNames["C3_folder"]
    elif _chip_id == 13:
        return DLSEBinFolderNames["C5_folder"]
    elif _chip_id == 23:
        return DLSEBinFolderNames["C5_folder"]
    else:
        logger.log("db_get_bin_folder: error, unsupported chip id!")
        return 0

def db_get_dlse_lic_via_serial(_serial_port: str) -> str | None:
    """Downloads the settings partition from ESP32 and extracts the license file.
    Returns the path to the extracted license file or None if an error occurs."""
    logger = DBLogger()

    def progress_fn(data_len, length, offset):
        print(f"{data_len} {length} {offset}")

    esp = None
    try:
        # Connect to the ESP32
        esp = detect_chip(_serial_port)
        logger.log(f"Connected to {_serial_port}...")

        # Read the settings partition from flash
        logger.log(f"Reading settings partition at address 0x{DLSE_SETTINGS_PARTITION_ADDRESS:x}...")
        partition_data = esp.read_flash(offset=DLSE_SETTINGS_PARTITION_ADDRESS, length=DLSE_SETTINGS_PARTITION_SIZE, progress_fn=progress_fn)

        # Parse the NVS partition
        nvs_partition = NVS_Partition("settings", bytearray(partition_data))

        # Search for the license in namespace "license" with key "db_lic_key"
        license_data = None
        license_namespace_id = None

        # First, find the namespace ID for "license"
        for page in nvs_partition.pages:
            if page.is_empty:
                continue
            for entry in page.entries:
                if entry.state == "Written" and entry.metadata['type'] == 'uint8_t' and entry.key == "license":
                    license_namespace_id = entry.metadata['namespace']
                    break
            if license_namespace_id is not None:
                break

        if license_namespace_id is None:
            logger.log("❌ Error: 'license' namespace not found in NVS partition")
            return None

        # Now find the blob with key "db_lic_key" in that namespace
        for page in nvs_partition.pages:
            if page.is_empty:
                continue
            for entry in page.entries:
                if (entry.state == "Written" and
                    entry.metadata['namespace'] == license_namespace_id and
                    entry.key == "db_lic_key" and
                    entry.metadata['type'] == 'blob'):

                    # Extract blob data from child entries
                    blob_data = bytearray()
                    for child in entry.children:
                        blob_data += child.raw

                    # Trim to actual size
                    if entry.data and 'size' in entry.data:
                        blob_data = blob_data[:entry.data['size']]

                    license_data = bytes(blob_data)
                    break
            if license_data is not None:
                break

        if license_data is None:
            logger.log("❌ Error: 'db_lic_key' blob not found in 'license' namespace")
            return None

        # Save the license file to a temporary location
        temp_dir = tempfile.gettempdir()
        license_file_path = os.path.join(temp_dir, "extracted_license.dlselic")

        with open(license_file_path, 'wb') as f:
            f.write(license_data)

        logger.log(f"✅ License extracted successfully to: {license_file_path}")
        # ToDo: Check validity of license file
        return license_file_path

    except Exception as e:
        logger.log(f"❌ Error extracting license: {e}")
        return None
    finally:
        if esp is not None:
            esp._port.close()

def db_get_esp32_chip_id(_serial_port: str) -> int | None:
    """Connects to the ESP32 and gets the chip ID (tells us if it is a C3, C5 or C6 module).
    Returns None if an error occurs."""
    logger = DBLogger()
    esp = None
    chip_id = None
    try:
        esp = detect_chip(_serial_port)
        print(f"Connected to {_serial_port}...")
        try:
            # Determine Chip ID (integer)
            chip_id = esp.get_chip_id()
        except Exception as e:
            logger.log(f"Error getting chip ID: {e}")
    except Exception as e:
        print(f"Error getting chip ID: {e}")
    finally:
        if esp is not None:
            esp._port.close()
    return chip_id

def db_create_address_binary_map(_esp_chip_id: int, _dlse_release_path: str,
                                 _settings_partition_bin_path: str) -> dict | None:
    """Creates the address to binary map based on flash_args.txt file.
    Returns None if an error occurs."""
    logger = DBLogger()
    bin_folder = db_get_bin_folder(_esp_chip_id)
    flash_args_path = os.path.join(_dlse_release_path, bin_folder, "flash_args.txt")

    if not os.path.exists(flash_args_path):
        logger.log(f"Error: flash_args.txt not found at {flash_args_path}")
        return None

    address_binary_map = {}
    try:
        with open(flash_args_path, 'r') as f:
            content = f.read().strip()
            # Split by whitespace and parse address-file pairs
            parts = content.split()
            i = 0
            while i < len(parts):
                part = parts[i]
                # Check if this part is an address (starts with 0x)
                if part.startswith('0x'):
                    address = int(part, 16)
                    # Next part should be the binary file
                    if i + 1 < len(parts):
                        binary_file_path = parts[i + 1]
                        # Extract just the filename from the path
                        binary_filename = os.path.basename(binary_file_path)
                        address_binary_map[address] = os.path.join(_dlse_release_path, bin_folder, binary_filename)
                        i += 2
                    else:
                        i += 1
                else:
                    i += 1
        # Add settings partition at the end
        address_binary_map[DLSE_SETTINGS_PARTITION_ADDRESS] = _settings_partition_bin_path
        return address_binary_map
    except Exception as e:
        logger.log(f"Error parsing flash_args.txt: {e}")
        return None


def db_get_activation_key(_serial_port: str) -> str | None:
    """Connects to the ESP32 and calculates the activation key. Returns None if an error occurs."""
    logger = DBLogger()
    activation_key = None
    esp = None
    try:
        # Connect to the ESP32
        # defaults: initial_baud=460800, trace_enabled=False, connect_mode='default_reset'
        esp = detect_chip(_serial_port)
        print(f"Connected to {_serial_port}...")

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
            logger.log(f"Chip Type: {chip_type} ID: {chip_id} Rev: {chip_rev}")

            # Use little-endian (<)
            # Ensure mac is bytes
            mac_bytes = bytes(mac)
            packed_data = struct.pack('<6sBH', mac_bytes, chip_id, chip_rev)

            activation_key = base64.b64encode(packed_data).decode('utf-8')

        except Exception as e:
            logger.log(f"Error calculating activation key: {e}")

    except Exception as e:
        logger.log(f"Error: {e}")
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
    logger = DBLogger()
    if not os.path.exists(_settings_csv_file_path):
        logger.log(f"❌ Error: The file '{_settings_csv_file_path}' was not found.")
        return None

    if not os.path.exists(_license_file_path):
        logger.log(f"❌ Error: The file '{_license_file_path}' was not found.")
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
            reader = csv.reader(f, quotechar='#')
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
            logger.log(f"Updated existing license key.")
        else:
            # Key does not exist
            if not header_exists:
                rows.append(license_namespace_header)
            rows.append(license_key_row)
            logger.log(f"Appended license key.")

        # Determine output file path
        output_file_path = _settings_csv_file_path
        if create_new_file:
            base, ext = os.path.splitext(_settings_csv_file_path)
            output_file_path = f"{base}_lic_added{ext}"
            logger.log(f"Creating new settings file: '{output_file_path}'")
        else:
            logger.log(f"Updating existing settings file: '{output_file_path}'")

        # Write back to CSV file
        with open(output_file_path, 'w', newline='') as f:
            writer = csv.writer(f, quotechar='#')
            writer.writerows(rows)

        logger.log(f"✅ Created combined license and settings file: '{output_file_path}'")
        return output_file_path

    except Exception as e:
        logger.log(f"❌ Error updating '{_settings_csv_file_path}': {e}")
        return None


def db_api_request_license_file(_activation_key: str, _token: str, _output_path="received_licenses/",
                                _license_type=DBLicenseType.ACTIVATED, _validity_days=0,
                                base_url="https://drone-bridge.com/api/license/generate") -> str | None:
    """
    Requests the license file from the licensing server.
    """
    logger = DBLogger()
    params = {
        "activationKey": _activation_key,
        "licenseType": _license_type.value,
        "validityDays": str(_validity_days),
    }
    headers = {
        "Authorization": f"Bearer {_token}"
    }

    try:
        logger.log(f"Requesting license from {base_url}...")
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
            logger.log(f"✅ License generated and saved to '{filename}'")
            return filename
        else:
            logger.log(f"❌ Failed to generate license. Status Code: {response.status_code}")
            logger.log(f"Response: {response.text}")
            return None
    except Exception as e:
        logger.log(f"❌ Error: {e}")
        return None

def db_parameters_generate_binary(_path_to_settings_csv: str, partition_size="0x6000") -> str | None:
    """
    Generates a NVS binary partition from the settings CSV file using the esp-idf-nvs-partition-gen tool.
    Returns the path to the generated .bin file or None if failed.
    """
    logger = DBLogger()
    script_dir = os.path.dirname(os.path.abspath(__file__))
    nvs_tool_path = os.path.join(script_dir, "esp-idf-nvs-partition-gen", "esp_idf_nvs_partition_gen", "nvs_partition_gen.py")

    if not os.path.exists(nvs_tool_path):
        logger.log(f"❌ Error: NVS partition generator tool not found at '{nvs_tool_path}'")
        return None

    if not os.path.exists(_path_to_settings_csv):
        logger.log(f"❌ Error: Input CSV file '{_path_to_settings_csv}' not found")
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

    logger.log(f"Generating binary from '{_path_to_settings_csv}'...")
    try:
        # Run the script and capture output
        result = subprocess.run(cmd, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        print(result.stdout)
        logger.log(f"✅ Successfully created '{output_bin}'")
        return output_bin
    except subprocess.CalledProcessError as e:
        logger.log(f"❌ Error generating binary: {e}")
        logger.log("STDOUT:", e.stdout)
        logger.log("STDERR:", e.stderr)
        return None
    except Exception as e:
        logger.log(f"❌ Error executing NVS tool: {e}")
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
    logger = DBLogger()
    if not address_binary_map:
        logger.log("Error: No binaries provided for flashing.")
        return False

    # Verify files exist
    for addr, path in address_binary_map.items():
        if not os.path.exists(path):
            logger.log(f"Error: File not found '{path}' for address {addr}")
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

    logger.log(f"Starting flash operation on {serial_port}...")
    try:
        # Using subprocess to isolate esptool execution
        subprocess.run(cmd, check=True)
        logger.log("✅ Flashing completed successfully!")
        return True
    except subprocess.CalledProcessError as e:
        logger.log(f"❌ Flashing failed with error code {e.returncode}")
        return False
    except Exception as e:
        logger.log(f"❌ An error occurred: {e}")
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
    logger = DBLogger()
    try:
        with FileWithProgress(file_path, None) as data: # The callback is now handled internally
            response = requests.post(url, data=data)
            response.raise_for_status()
            return response
    except Exception as e:
        logger.log(f"\n❌ Upload failed: {e}")
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


def db_csv_update_parameters(_csv_settings_file_path: str, new_ip=None, new_hostname=None) -> bool:
    """
    Reads the CSV, increments the IP and hostname by one if no new_ip or new_hostname are given
    Else it takes the new_ip or new_hostname.
    Saves the file.
    Updated .csv file can be used to generate a new settings.bin (partition) that can be flashed via serial.
    Returns True if successful, False otherwise.
    """
    logger = DBLogger()
    if not os.path.exists(_csv_settings_file_path):
        logger.log(f"Error: The file '{_csv_settings_file_path}' was not found.")
        return False

    comments = []
    data_rows = []
    fieldnames = None

    # Read the data from the CSV file
    try:
        with open(_csv_settings_file_path, 'r', newline='') as f:
            # We read the file line-by-line first
            for line in f:
                if line.lstrip().startswith('#'):
                    comments.append(line)  # Store the comment line as-is
                elif not fieldnames:
                    # The first non-comment line is our header
                    fieldnames = line.strip().split(',')
                else:
                    # Use DictReader logic for the data
                    reader = csv.DictReader([line], fieldnames=fieldnames)
                    data_rows.append(next(reader))
    except Exception as e:
        logger.log(f"Error reading '{_csv_settings_file_path}': {e}")
        return False

    new_ip_octet = None
    original_hostname = None

    ip_updated = False
    hostname_updated = False

    # Find and update the IP address and hostname in the data
    for row in data_rows:
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
                    logger.log(f"Updated ip_sta to: {row['value']}")
                    ip_updated = True
                except (ValueError, IndexError) as e:
                    logger.log(f"Could not parse IP address '{row['value']}': {e}")
                    return False # Stop execution if IP is invalid
            elif validate_ip(new_ip):
                # Use given IP
                row['value'] = new_ip
                ip_parts = row['value'].split('.')
                new_ip_octet = int(ip_parts[-1])
                ip_updated = True
            else:
                logger.log(f"Given IP address '{new_ip}' is invalid. Skipping change of IP address.")
                return False

        if row['key'] == 'wifi_hostname':
            # Store the original hostname to modify it after finding the new IP octet
            original_hostname = row['value']


    # Update the hostname using the new IP octet
    for row in data_rows:
        if row['key'] == 'wifi_hostname':
            if new_hostname is None:
                if new_ip_octet is not None and original_hostname is not None:
                    # This logic assumes the base hostname doesn't end in numbers.
                    # A more robust way would be to strip old numbers if they exist.
                    base_hostname = ''.join(filter(str.isalpha, original_hostname))
                    row['value'] = f"{base_hostname}{new_ip_octet}"
                    logger.log(f"Updated wifi_hostname to: {row['value']}")
                    hostname_updated = True
                    break # Stop after updating
                else:
                    logger.log("Error setting wifi_hostname. New IP octet not set or original hostname not set.")
            else:
                row['value'] = new_hostname
                logger.log(f"Updated wifi_hostname to: {row['value']}")
                hostname_updated = True
                break # Stop after updating

    if not ip_updated and not hostname_updated:
        logger.log("ERROR: Did not update IP and hostname")
        return False
    else:
        # Write the modified data back to the CSV file
        try:
            with open(_csv_settings_file_path, 'w', newline='') as f:
                # Write the comments back at the top
                f.writelines(comments)

                # Write the CSV data
                writer = csv.DictWriter(f, fieldnames=fieldnames)
                writer.writeheader()
                writer.writerows(data_rows)
            logger.log(f"Successfully saved changes to '{_csv_settings_file_path}'.")
            return True
        except Exception as e:
            logger.log(f"Error writing to '{_csv_settings_file_path}': {e}")
            return False


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


def db_merge_user_parameters_with_release(_user_csv_path: str, _release_path: str) -> str | None:
    """
    Merges user parameter values into the release parameter file.
    Takes parameter values from the user's CSV and copies them into a copy of the release CSV.
    Detects and reports missing or obsolete parameters.

    :param _user_csv_path: Path to the user's parameter CSV file
    :param _release_path: Path to the release root directory (e.g., "DroneBridge_ESP32DLSE_BETA3")
    :return: Path to the merged CSV file or None if an error occurs
    """
    logger = DBLogger()
    release_csv_path = os.path.join(_release_path, "db_show_params.csv")

    # Verify both files exist
    if not os.path.exists(_user_csv_path):
        logger.log(f"❌ Error: User parameter file '{_user_csv_path}' not found.")
        return None

    if not os.path.exists(release_csv_path):
        logger.log(f"❌ Error: Release parameter file '{release_csv_path}' not found.")
        return None

    try:
        # Read user parameters
        user_params = {}
        user_namespaces = []
        with open(_user_csv_path, 'r', newline='') as f:
            reader = csv.DictReader(f)
            for row in reader:
                key = row.get('key', '').strip()
                if row.get('type', '').strip() == 'namespace':
                    user_namespaces.append(key)
                else:
                    user_params[key] = row

        # Read release parameters
        release_params = {}
        release_rows = []
        release_namespaces = []
        with open(release_csv_path, 'r', newline='') as f:
            reader = csv.DictReader(f)
            fieldnames = reader.fieldnames
            for row in reader:
                key = row.get('key', '').strip()
                if row.get('type', '').strip() == 'namespace':
                    release_namespaces.append(key)
                release_params[key] = row
                release_rows.append(row)

        # Detect parameter differences
        user_keys = set(user_params.keys())
        release_keys = set(release_params.keys())

        missing_in_user = release_keys - user_keys
        obsolete_in_user = user_keys - release_keys

        # Report differences
        if missing_in_user:
            logger.log(f"⚠️  Warning: {len(missing_in_user)} parameter(s) are specified in release settings file but not found/set in the file you provided:")
            logger.log(f"    Check and add these parameters to your settings file with the desired values. Otherwise the firmware will assume the default parameter value which may lead to unexpected behavior!")
            for key in sorted(missing_in_user):
                if key:  # Skip empty keys
                    logger.log(f"   - {key}")

        if obsolete_in_user:
            logger.log(f"⚠️  Warning: {len(obsolete_in_user)} parameter(s) are specified in your settings file are not found in release settings file:")
            logger.log(f"    These parameters likely became obsolete in the newer release or you have made an error in your settings file.")
            for key in sorted(obsolete_in_user):
                if key:  # Skip empty keys
                    logger.log(f"   - {key}")

        if not missing_in_user and not obsolete_in_user:
            logger.log("✅ User parameters match release parameters perfectly.")

        # Create merged CSV: Start with release structure, update with user values
        merged_rows = []
        for row in release_rows:
            key = row.get('key', '').strip()
            if key in user_params:
                # Use user's value for this parameter
                merged_row = row.copy()
                merged_row['value'] = user_params[key].get('value', '')
                merged_rows.append(merged_row)
            else:
                # Keep release default
                merged_rows.append(row)

        # Create output filename
        base, ext = os.path.splitext(_user_csv_path)
        output_path = f"{base}_merged{ext}"

        # Write merged CSV
        with open(output_path, 'w', newline='') as f:
            writer = csv.DictWriter(f, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(merged_rows)

        logger.log(f"✅ Created merged parameter file: '{output_path}'")
        return output_path

    except Exception as e:
        logger.log(f"❌ Error merging parameters: {e}")
        return None
