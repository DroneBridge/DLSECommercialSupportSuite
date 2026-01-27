# MIT License
# Copyright (c) 2026 Wolfgang Christl
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

"""
ESP32 DLSE Remote Reset Tool

Reboots all ESP32 devices running DroneBridge for ESP32 DLSE
This script broadcasts a MAVLink command to reboot specific components on the network.

Configuration Constants:
    TARGET_IP (str): The broadcast IP address (default: 192.168.1.255).
    TARGET_PORT (int): The UDP port the ESP32s are listening on (default: 14555).
    SOURCE_SYSTEM (int): The MAVLink system ID of this sender (GCS).
    TARGET_SYSTEM (int): The target system ID (0 for broadcast).
    TARGET_COMPONENT (int): The target component ID (0 for broadcast).

Command Sent:
    MAV_CMD_PREFLIGHT_REBOOT_SHUTDOWN (246) with Param 3 set to 1.
"""

import os
os.environ['MAVLINK20'] = '1' # Use MAVLink Version 2
from pymavlink import mavutil


# --- Configuration ---
TARGET_IP = '192.168.1.255' # Send to UDP broadcast address to make all ESP32s reboot
TARGET_PORT = 14555 # Broadcast enabled port on the DLSE side -> Send command there
SOURCE_SYSTEM = 255  # GCS ID
TARGET_SYSTEM = 0  # Drone System ID (0 for broadcast)
TARGET_COMPONENT = 0  # Drone Component ID (0 for broadcast)


def send_reboot_command():
    # Create the connection
    # For a real drone connection, might be 'udpin:0.0.0.0:14550' if listening
    # or 'udpout:...' if sending to a specific target.
    connection_string = f'udpout:{TARGET_IP}:{TARGET_PORT}'

    print(f"Connecting to {connection_string}...")
    master = mavutil.mavlink_connection(connection_string, source_system=SOURCE_SYSTEM)

    # Wait for a heartbeat to ensure connection (optional, good practice)
    # print("Waiting for heartbeat...")
    # master.wait_heartbeat()

    print(f"Sending MAV_CMD_PREFLIGHT_REBOOT_SHUTDOWN to Sys:{TARGET_SYSTEM} Comp:{TARGET_COMPONENT}")

    # https://mavlink.io/en/messages/common.html#MAV_CMD_PREFLIGHT_REBOOT_SHUTDOWN
    # Param 1: Autopilot (0: Do nothing, 1: Reboot, 2: Shutdown, 3: Reboot and stay in bootloader)
    # Param 2: Companion Computer (0: Do nothing, 1: Reboot, 2: Shutdown, 3: Reboot and stay in bootloader)
    # Param 3: Components (Specific component reboot) -> Request asked for 1
    # Param 4: Reserved -> Request asked for 0

    # Constructing MAVLink Command Long
    master.mav.command_long_send(
        TARGET_SYSTEM,
        TARGET_COMPONENT,
        mavutil.mavlink.MAV_CMD_PREFLIGHT_REBOOT_SHUTDOWN,  # command_id: 246
        0,  # confirmation
        0,  # param1 (Autopilot action - Default 0)
        0,  # param2 (Companion action - Default 0)
        1,  # param3 (Wiper/Component reboot logic as requested)
        0,  # param4 (Requested 0)
        0,  # param5
        0,  # param6
        0  # param7
    )

    print("Command sent successfully.")


if __name__ == "__main__":
    send_reboot_command()
