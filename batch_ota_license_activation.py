# MIT License
# Copyright (c) 2026 Wolfgang Christl & foremost systems UG (haftungsbeschraenkt)
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
import os
import sys
import time
from pathlib import Path
from typing import Any, Dict, Set

import requests

from dlse_cli_utils import validate_activation_token
from DroneBridgeCommercialSupportSuite import (
    DBLogger,
    DBLicenseType,
    DLSE_LICENSE_FOLDER,
    db_api_activate_dlse_device,
    db_api_create_request_session,
    db_scan_for_esp32_devices,
    db_scan_for_esp32_devices_by_ip_range,
)


MY_SECRET_TOKEN = "<Add Token here or as an environment variable DRONEBRIDGE_SECRET_TOKEN or as command line argument --token>"
SUBNET_MASK = "192.168.1.0/24"
ESP32_LOCAL_BROADCAST_PORT = 14555
ESP32_REMOTE_BROADCAST_PORT = 14550
SCAN_INTERVAL = 10
LICENSE_TYPE = DBLicenseType.ACTIVATED
LICENSE_VALIDITY_DAYS = 0
HTTP_FALLBACK_TIMEOUT = 1.0
HTTP_FALLBACK_MAX_WORKERS = 20
FORCE_REST_DISCOVERY = False


def process_dlse_device(device: Dict[str, Any], session: requests.Session,
                        successful_ips: Set[str], processed_keys: Set[str],
                        logger: DBLogger) -> bool:
    """
    Process one ESP32 with the shared OTA license activation workflow.

    :param device: Discovered device dictionary with at least an ``ip`` key.
    :param session: Requests session for ESP32 REST calls.
    :param successful_ips: Set updated when a device is activated or already active.
    :param processed_keys: Set used to skip duplicate activation keys.
    :param logger: DBLogger instance for script output.
    :return: True when activation succeeded, was already active, or was skipped as duplicate.
    """
    result = db_api_activate_dlse_device(
        device=device,
        session=session,
        token=MY_SECRET_TOKEN,
        processed_keys=processed_keys,
        successful_ips=successful_ips,
        license_type=LICENSE_TYPE,
        validity_days=LICENSE_VALIDITY_DAYS,
        logger=logger,
    )
    return result.success


def discover_dlse_devices(logger: DBLogger) -> list[dict[str, Any]]:
    """
    Discover ESP32 DLSE devices with MAVLink first and HTTP subnet scanning as fallback.

    :param logger: DBLogger instance for script output.
    :return: Discovered device dictionaries suitable for ``db_api_activate_dlse_device``.
    """
    if FORCE_REST_DISCOVERY:
        logger.log("Forced REST discovery selected. Skipping MAVLink discovery.")
        return db_scan_for_esp32_devices_by_ip_range(
            subnet_mask=SUBNET_MASK,
            timeout=HTTP_FALLBACK_TIMEOUT,
            max_workers=HTTP_FALLBACK_MAX_WORKERS,
        )

    devices = db_scan_for_esp32_devices(
        subnet_mask=SUBNET_MASK,
        timeout=2,
        esp32_broadcast_port=ESP32_LOCAL_BROADCAST_PORT,
        local_brcst_port=ESP32_REMOTE_BROADCAST_PORT,
        _beta_4_support=True,
    )
    if devices:
        return devices

    logger.log("MAVLink discovery found no ESP32 devices. Falling back to HTTP subnet scan.")
    return db_scan_for_esp32_devices_by_ip_range(
        subnet_mask=SUBNET_MASK,
        timeout=HTTP_FALLBACK_TIMEOUT,
        max_workers=HTTP_FALLBACK_MAX_WORKERS,
    )


def parse_args() -> argparse.Namespace:
    """
    Parse command-line arguments for the OTA license activation script.

    :return: Parsed argparse namespace.
    """
    parser = argparse.ArgumentParser(description="Install DroneBridge DLSE licenses on ESP32 devices over the air.")
    parser.add_argument("--token", required=False, type=str,
                        help="Secret token for the DroneBridge licensing server.")
    parser.add_argument("--subnetmask", required=False, type=str,
                        help="Subnet mask describing where to scan. Default: 192.168.1.0/24 for IP range: 192.168.1.1 to 192.168.1.254")
    parser.add_argument("--esp32localbrcstport", required=False, type=int,
                        help="ESP32 broadcast port. Default: 14555")
    parser.add_argument("--esp32remotebrcstport", required=False, type=int,
                        help="Local broadcast receive port. Default: 14550")
    parser.add_argument("-e", "--evaluation", action="store_true",
                        help="Request 60-day evaluation licenses instead of activated licenses.")
    parser.add_argument("--force-rest", action="store_true",
                        help="Skip MAVLink discovery and use HTTP subnet scanning directly.")
    return parser.parse_args()


def apply_args(args: argparse.Namespace) -> None:
    """
    Apply command-line and environment overrides to module-level script settings.

    :param args: Parsed command-line arguments.
    :return: None. Updates module-level configuration.
    """
    global MY_SECRET_TOKEN, SUBNET_MASK, ESP32_LOCAL_BROADCAST_PORT, ESP32_REMOTE_BROADCAST_PORT
    global LICENSE_TYPE, LICENSE_VALIDITY_DAYS, FORCE_REST_DISCOVERY

    env_token = os.environ.get("DRONEBRIDGE_SECRET_TOKEN")
    if env_token:
        MY_SECRET_TOKEN = env_token
    if args.token:
        MY_SECRET_TOKEN = args.token
    if args.subnetmask:
        SUBNET_MASK = args.subnetmask
    if args.esp32localbrcstport:
        ESP32_LOCAL_BROADCAST_PORT = args.esp32localbrcstport
    if args.esp32remotebrcstport:
        ESP32_REMOTE_BROADCAST_PORT = args.esp32remotebrcstport
    if args.evaluation:
        LICENSE_TYPE = DBLicenseType.EVALUATION
        LICENSE_VALIDITY_DAYS = 60
    else:
        LICENSE_TYPE = DBLicenseType.ACTIVATED
        LICENSE_VALIDITY_DAYS = 0
    FORCE_REST_DISCOVERY = bool(getattr(args, "force_rest", False))


def main() -> None:
    """
    Run the continuous OTA license activation loop.

    The script preserves the original batch behavior: every discovered device is
    processed on each scan cycle, with duplicate activation keys skipped.
    A valid activation token must be supplied before discovery starts.
    """
    global MY_SECRET_TOKEN

    apply_args(parse_args())
    try:
        MY_SECRET_TOKEN = validate_activation_token(MY_SECRET_TOKEN)
    except ValueError as e:
        print(f"Fatal: {e}")
        sys.exit(2)

    license_storage_dir = Path(DLSE_LICENSE_FOLDER)
    try:
        license_storage_dir.mkdir(parents=True, exist_ok=True)
        logger = DBLogger()
        logger.create_log_file("logs", log_file_prefix="dlse_ota_activation_log")
    except Exception as e:
        print(f"Fatal: Could not initialize storage or logger: {e}")
        sys.exit(1)

    session = db_api_create_request_session()
    successful_ips: Set[str] = set()
    processed_keys: Set[str] = set()

    logger.log(f"Starting DLSE Over-The-Air activation service. License storage: {license_storage_dir}")
    if LICENSE_TYPE == DBLicenseType.EVALUATION:
        logger.log("License mode: EVALUATION, validity: 60 days. Evaluation licenses are temporary and not cached.")
    else:
        logger.log("License mode: ACTIVATED, validity: permanent. Activated licenses are cached for offline recovery.")

    try:
        while True:
            cycle_start = time.time()

            try:
                devices = discover_dlse_devices(logger)

                for device in devices:
                    process_dlse_device(device, session, successful_ips, processed_keys, logger)
                    time.sleep(0.5)

            except Exception as e:
                logger.log(f"Scan cycle error: {e}")

            elapsed = time.time() - cycle_start
            if elapsed < SCAN_INTERVAL:
                time.sleep(SCAN_INTERVAL - elapsed)

    except KeyboardInterrupt:
        logger.log("Exiting auto license activation tool.")
        logger.log(f"Session total: {len(successful_ips)} devices activated or already activated")
        if LICENSE_TYPE == DBLicenseType.EVALUATION:
            logger.log("Evaluation licenses were temporary and are not stored in the offline license cache.")
        else:
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
