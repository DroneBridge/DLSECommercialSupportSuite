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
from concurrent.futures import ThreadPoolExecutor, as_completed
from typing import Any

from DroneBridgeCommercialSupportSuite import (
    DBLogger,
    db_api_create_request_session,
    db_api_reboot_esp32_device,
    db_mavlink_reboot_esp32_devices,
    db_scan_for_esp32_devices,
    db_scan_for_esp32_devices_by_ip_range,
)


SUBNET_MASK = "192.168.1.0/24"
ESP32_LOCAL_BROADCAST_PORT = 14555
ESP32_REMOTE_BROADCAST_PORT = 14550
MAVLINK_DISCOVERY_TIMEOUT = 3
HTTP_FALLBACK_TIMEOUT = 1.0
HTTP_FALLBACK_MAX_WORKERS = 20


def parse_args() -> argparse.Namespace:
    """
    Parse command-line arguments for the OTA fleet reboot script.

    :return: Parsed argparse namespace with discovery, reboot, and HTTP scan options.
    """
    parser = argparse.ArgumentParser(description="Reboot DroneBridge DLSE ESP32 devices over the air.")
    parser.add_argument("--subnetmask", required=False, type=str,
                        help="Subnet mask describing where to scan. Default: 192.168.1.0/24")
    parser.add_argument("--esp32localbrcstport", required=False, type=int,
                        help="ESP32 broadcast port. Default: 14555")
    parser.add_argument("--esp32remotebrcstport", required=False, type=int,
                        help="Local broadcast receive port. Default: 14550")
    parser.add_argument("--force-rest", action="store_true",
                        help="Skip MAVLink discovery and reboot via HTTP scan plus POST /api/settings.")
    parser.add_argument("--http-timeout", required=False, type=float,
                        help="Per-host HTTP timeout for scan and REST reboot. Default: 1.0 seconds")
    parser.add_argument("--http-workers", required=False, type=int,
                        help="Maximum concurrent HTTP scan/reboot workers. Default: 20")
    return parser.parse_args()


def apply_args(args: argparse.Namespace) -> None:
    """
    Apply command-line overrides to module-level script settings.

    :param args: Parsed command-line arguments.
    :return: None. Updates module-level configuration.
    """
    global SUBNET_MASK, ESP32_LOCAL_BROADCAST_PORT, ESP32_REMOTE_BROADCAST_PORT
    global HTTP_FALLBACK_TIMEOUT, HTTP_FALLBACK_MAX_WORKERS

    if args.subnetmask:
        SUBNET_MASK = args.subnetmask
    if args.esp32localbrcstport:
        ESP32_LOCAL_BROADCAST_PORT = args.esp32localbrcstport
    if args.esp32remotebrcstport:
        ESP32_REMOTE_BROADCAST_PORT = args.esp32remotebrcstport
    if args.http_timeout is not None:
        HTTP_FALLBACK_TIMEOUT = max(0.1, args.http_timeout)
    if args.http_workers is not None:
        HTTP_FALLBACK_MAX_WORKERS = max(1, min(args.http_workers, 64))


def discover_reboot_targets(force_rest: bool, logger: DBLogger) -> tuple[str, list[dict[str, Any]]]:
    """
    Discover ESP32 reboot targets and choose the reboot method.

    :param force_rest: When ``True``, skip MAVLink discovery and use HTTP scanning.
    :param logger: DBLogger instance for script output.
    :return: Tuple of selected method name (``"mavlink"`` or ``"rest"``) and discovered devices.
    """
    if not force_rest:
        devices = db_scan_for_esp32_devices(
            subnet_mask=SUBNET_MASK,
            timeout=MAVLINK_DISCOVERY_TIMEOUT,
            esp32_broadcast_port=ESP32_LOCAL_BROADCAST_PORT,
            local_brcst_port=ESP32_REMOTE_BROADCAST_PORT,
            _beta_4_support=True,
        )
        if devices:
            return "mavlink", devices

        logger.log("MAVLink discovery found no ESP32 devices. Falling back to HTTP subnet scan.")
    else:
        logger.log("Forced REST reboot mode selected. Skipping MAVLink discovery.")

    devices = db_scan_for_esp32_devices_by_ip_range(
        subnet_mask=SUBNET_MASK,
        timeout=HTTP_FALLBACK_TIMEOUT,
        max_workers=HTTP_FALLBACK_MAX_WORKERS,
    )
    return "rest", devices


def log_discovered_devices(method: str, devices: list[dict[str, Any]], logger: DBLogger) -> None:
    """
    Log the reboot method and discovered devices before asking for confirmation.

    :param method: Selected reboot method, either ``"mavlink"`` or ``"rest"``.
    :param devices: Discovered device dictionaries.
    :param logger: DBLogger instance for script output.
    :return: None.
    """
    logger.log(f"Selected reboot method: {method.upper()}")
    for device in devices:
        ip = device.get("ip", "<unknown>")
        sys_id = device.get("sys_id")
        version = device.get("flight_sw_version", {}).get("version_str")
        detail_parts = [f"IP {ip}"]
        if sys_id is not None:
            detail_parts.append(f"SYS_ID: {sys_id}")
        if version:
            detail_parts.append(f"firmware Version {version}")
        logger.log("\t[X] " + " - ".join(detail_parts))


def confirm_reboot(method: str, devices: list[dict[str, Any]]) -> bool:
    """
    Ask the operator to confirm the one-shot fleet reboot.

    :param method: Selected reboot method shown in the prompt.
    :param devices: Discovered device dictionaries used for the device count.
    :return: ``True`` when the operator confirms with ``y`` or ``yes``.
    """
    user_input = input(
        f"\nDo you want to reboot {len(devices)} detected ESP32 device(s) using {method.upper()}? (y/n): "
    )
    return user_input.lower() in ["y", "yes"]


def reboot_with_mavlink(logger: DBLogger) -> bool:
    """
    Send one MAVLink broadcast reboot command for all listening ESP32 devices.

    :param logger: DBLogger instance for script output.
    :return: ``True`` when the MAVLink reboot command was sent.
    """
    return db_mavlink_reboot_esp32_devices(
        subnet_mask=SUBNET_MASK,
        esp32_broadcast_port=ESP32_LOCAL_BROADCAST_PORT,
        logger=logger,
    )


def reboot_with_rest(devices: list[dict[str, Any]], logger: DBLogger) -> tuple[list[str], list[str]]:
    """
    Reboot discovered ESP32 devices through ``POST /api/settings`` in parallel.

    :param devices: Device dictionaries with an ``ip`` key.
    :param logger: DBLogger instance for script output.
    :return: Tuple of successful and failed device IP lists.
    """
    successful_ips: list[str] = []
    failed_ips: list[str] = []
    workers = max(1, min(HTTP_FALLBACK_MAX_WORKERS, 64))

    def reboot_one(device: dict[str, Any]) -> tuple[str, bool]:
        """
        Reboot one device with an isolated request session for worker-thread use.

        :param device: Device dictionary with an ``ip`` key.
        :return: Tuple of device IP and reboot success flag.
        """
        device_ip = str(device.get("ip", "")).strip()
        if not device_ip:
            return "", False
        session = db_api_create_request_session()
        try:
            return device_ip, db_api_reboot_esp32_device(
                session,
                device_ip,
                timeout=HTTP_FALLBACK_TIMEOUT,
                logger=logger,
            )
        finally:
            session.close()

    with ThreadPoolExecutor(max_workers=workers) as executor:
        future_map = {executor.submit(reboot_one, device): device for device in devices}
        for future in as_completed(future_map):
            try:
                device_ip, success = future.result()
            except Exception as e:
                device_ip = str(future_map[future].get("ip", ""))
                logger.log(f"REST reboot error for {device_ip}: {e}")
                success = False

            if success:
                successful_ips.append(device_ip)
            elif device_ip:
                failed_ips.append(device_ip)

    successful_ips.sort()
    failed_ips.sort()
    return successful_ips, failed_ips


def main() -> None:
    """
    Run the one-shot OTA fleet reboot workflow.

    Discovery uses MAVLink first unless ``--force-rest`` is set. When MAVLink
    discovers at least one ESP32, the script sends a single MAVLink broadcast
    reboot command. Otherwise, it scans the IP range and reboots devices through
    ``POST /api/settings`` with an empty JSON body.
    """
    args = parse_args()
    apply_args(args)

    logger = DBLogger()
    logger.create_log_file("logs", log_file_prefix="dlse_ota_reboot_log")

    logger.log("Starting one-shot DLSE ESP32 fleet reboot.")
    logger.log("*** TURN OFF SKYBRUSH LIVE to free up the broadcast port when using MAVLink discovery/reboot ***")

    method, devices = discover_reboot_targets(args.force_rest, logger)
    if not devices:
        logger.log("No DLSE devices found in the local network. Nothing to reboot.")
        return

    log_discovered_devices(method, devices, logger)
    if not confirm_reboot(method, devices):
        logger.log("Fleet reboot cancelled by user.")
        return

    if method == "mavlink":
        success = reboot_with_mavlink(logger)
        if success:
            logger.log(f"MAVLink reboot command sent for {len(devices)} discovered ESP32 device(s).")
        else:
            logger.log("MAVLink reboot command failed before it could be sent.")
        return

    successful_ips, failed_ips = reboot_with_rest(devices, logger)
    logger.log(
        f"REST reboot finished. {len(successful_ips)} devices accepted reboot. {len(failed_ips)} devices failed."
    )
    logger.log("\nFailed devices:\n" + _format_ip_list_for_print(failed_ips))
    logger.log("\nSuccessful devices:\n" + _format_ip_list_for_print(successful_ips))


def _format_ip_list_for_print(items: list[str]) -> str:
    """
    Format a list of IP addresses for summary logging.

    :param items: IP addresses to format.
    :return: Human-readable list or ``(none)`` placeholder.
    """
    if not items:
        return "  (none)"
    return "\n".join(f"  - {item}" for item in items)


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\nExiting OTA reboot tool.")
