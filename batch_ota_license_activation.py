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
import pathlib
import time
import sys
from pathlib import Path
from typing import Set, Dict, Any
import requests

from DroneBridgeCommercialSupportSuite import DBLogger, db_scan_for_esp32_devices, \
    db_api_request_license_file, DLSE_LICENSE_FOLDER, db_dlse_validate_license, db_api_upload_license, \
    db_api_check_is_activated, db_api_get_activation_key, db_api_create_request_session

# Configuration
MY_SECRET_TOKEN = "<Add Token here or as command line argument --token>"
SUBNET_MASK = '192.168.1.0/24'      # IP address range to scan for devices to activate. Here it will scan for 192.168.1.0-254
ESP32_LOCAL_BROADCAST_PORT = 14555  # As configured in the web interface of the ESP32 (open on your ESP32)
ESP32_REMOTE_BROADCAST_PORT = 14550 # As configured in the web interface of the ESP32 (open on your GCS)

# Parameters for retries - adjust if necessary
SCAN_INTERVAL = 10  # Seconds between scans

# =============================================================================
# DLSE OTA License Activation Tool
# Purpose: Scans a local network for ESP32 devices and activates DroneBridge
#          licenses on them over-the-air.
# =============================================================================

# -----------------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------------
# - Secret token, subnet mask, broadcast ports, retry/timeout parameters
#   defined as module-level constants (overridable via CLI args)

# -----------------------------------------------------------------------------
# Core Functions
# -----------------------------------------------------------------------------

# setup_retry_session()
#   Sets up an HTTP session with automatic exponential backoff retries for
#   transient server errors (429, 5xx).

# db_webapi_get_activation_key()
#   Calls GET /api/system/info on a device to retrieve its activation key,
#   with manual retry loop and backoff.

# db_webapi_upload_license()
#   Posts a 128-byte binary license file to POST /api/license on a device.
#   Distinguishes permanent vs. retryable failures.

# db_webapi_check_is_activated()
#   Calls GET /api/system/info to check if a device is already activated,
#   avoiding redundant API calls.

# process_dlse_device()
#   Orchestrates the full activation flow for a single device:
#     1. Get activation key
#     2. Skip if duplicate key or already activated
#     3. Fetch license from server
#     4. Upload license to device

# -----------------------------------------------------------------------------
# main() - Entry Point
# -----------------------------------------------------------------------------

# 1. Init
#      - Creates license storage directory and log file
#      - Exits fatally on failure

# 2. CLI Parsing
#      - Accepts: --token, --subnetmask,
#                 --esp32localbrcstport, --esp32remotebrcstport

# 3. Main Loop (runs indefinitely on SCAN_INTERVAL timer)
#      - Scans subnet for ESP32 devices
#      - Processes each discovered device with rate limiting
#      - Handles scan-level exceptions without crashing

# 4. Shutdown (KeyboardInterrupt)
#      - Logs session summary:
#          - Total activated device count
#          - License storage path
#          - Processed IPs and activation keys


def process_dlse_device(device: Dict[str, Any], session: requests.Session,
                        successful_ips: Set[str], processed_keys: Set[str], logger) -> bool:
    """
    Process single device with full error isolation.
    Stores license files in /received_licenses
    Returns True if successful or already activated.
    """
    device_ip = device.get("ip")
    sys_id = device.get("sys_id")
    if not device_ip or not isinstance(device_ip, str):
        print("❌ Invalid device IP (process_dlse_device())")
        return False

    try:
        # Get key
        activation_key = db_api_get_activation_key(session, device_ip, MY_SECRET_TOKEN)
        if not activation_key:
            logger.log(f"❌ Failed to get key for {device_ip}")
            return False

        if activation_key in processed_keys:
            # Skip this device, we already processed it
            return True

        # Skip if already activated
        if db_api_check_is_activated(session, device_ip):
            logger.log(f"Already activated: {device_ip} - SYS_ID: {sys_id} - {activation_key} skipping this device in future scans")
            successful_ips.add(device_ip)
            processed_keys.add(activation_key)
            return True

        # Get license file from license server
        lic_path = db_api_request_license_file(activation_key, MY_SECRET_TOKEN)
        if lic_path is None:
            logger.log("❌ Error getting license file from server")
            return False

        # Validate it offline again
        if not db_dlse_validate_license(lic_path, match_activation_key=activation_key):
            return False

        # Attempt upload
        success, msg = db_api_upload_license(session, device_ip, pathlib.Path(lic_path))

        if success:
            logger.log(f"🔑 Activated {device_ip} - {activation_key} 🔑")
            successful_ips.add(device_ip)
            processed_keys.add(activation_key)
            return True
        else:
            logger.log(f"❌ Failed {device_ip}: {msg}")
            return False

    except Exception as e:
        logger.log(f"❌ Error processing {device_ip}: {e}")
        return False


def main():
    global MY_SECRET_TOKEN, SUBNET_MASK, ESP32_LOCAL_BROADCAST_PORT, ESP32_REMOTE_BROADCAST_PORT

    license_storage_dir = Path(DLSE_LICENSE_FOLDER)
    # Create storage directory on startup if it doesn't exist
    try:
        license_storage_dir.mkdir(parents=True, exist_ok=True)
        logger = DBLogger()
        logger.create_log_file("logs", log_file_prefix="dlse_ota_activation_log")
    except Exception as e:
        print(f"Fatal: Could not initialize storage or logger: {e}")
        sys.exit(1)

    parser = argparse.ArgumentParser(description='Install DroneBridge DLSE on ESP32.')
    parser.add_argument('--token', required=False, type=str,
                        help='Secret token to authenticate you with the DroneBridge licensing server')
    parser.add_argument('--subnetmask', required=False, type=str,
                        help='Subnet mask describing where to scan for devices. Default: 192.168.1.0/24')
    parser.add_argument('--esp32localbrcstport', required=False, type=int,
                        help='ESP32 broadcast port. Default: 14555')
    parser.add_argument('--esp32remotebrcstport', required=False, type=int,
                        help='ESP32 local broadcast port. Default: 14550'
    )
    args = parser.parse_args()

    if args.token:
        MY_SECRET_TOKEN = args.token
    if args.subnetmask:
        SUBNET_MASK = args.subnetmask
    if args.esp32localbrcstport:
        ESP32_LOCAL_BROADCAST_PORT = args.esp32localbrcstport
    if args.esp32remotebrcstport:
        ESP32_REMOTE_BROADCAST_PORT = args.esp32remotebrcstport

    session = db_api_create_request_session()
    successful_ips: Set[str] = set()
    processed_keys: Set[str] = set()

    logger.log(f"Starting DLSE Over-The-Air activation service. License storage: {license_storage_dir}")

    try:
        while True:
            cycle_start = time.time()

            try:
                # Find devices
                devices = db_scan_for_esp32_devices(
                    subnet_mask=SUBNET_MASK,
                    timeout=2,
                    esp32_broadcast_port=ESP32_LOCAL_BROADCAST_PORT,
                    local_brcst_port=ESP32_REMOTE_BROADCAST_PORT,
                    _beta_4_support=True
                )

                if devices:
                    for device in devices:
                        process_dlse_device(device, session, successful_ips, processed_keys, logger)
                        time.sleep(0.5)  # Rate limiting between devices
                else:
                    pass # No devices found

            except Exception as e:
                logger.log(f"Scan cycle error: {e}")

            # Maintain consistent scan interval
            elapsed = time.time() - cycle_start
            if elapsed < SCAN_INTERVAL:
                time.sleep(SCAN_INTERVAL - elapsed)

    except KeyboardInterrupt:
        logger.log("👋 Exiting auto license activation tool.")
        logger.log(f"Session total: {len(successful_ips)} devices activated or already activated")
        logger.log(f"All licenses stored in: {license_storage_dir}")
    except Exception as e:
        logger.log(f"Fatal error: {e}")
        raise
    finally:
        session.close()
        logger.log(f"Processed IPs: {successful_ips}")
        logger.log(f"Processed activation keys: {processed_keys}")

if __name__ == "__main__":
    main()