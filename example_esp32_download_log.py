import time
from pymavlink import mavutil

# --- Configuration ---
# Replace with your connection string (e.g., 'udp:127.0.0.1:14550' or a serial port)
CONNECTION_STRING = 'tcp:192.168.10.21:5760'
# Target system ID (usually 1 for the autopilot)
TARGET_SYSTEM = 99
# Target component ID (usually 1 for the main autopilot component)
TARGET_COMPONENT = 1
# The log ID index to start listing from (0 for the first log)
START_LOG_ID = 0
# The number of logs to request
LOGS_COUNT = 255  # Request all logs (up to 255)

# --- MAVLink Connection ---
print(f"Connecting to {CONNECTION_STRING}...")
master = mavutil.mavlink_connection(CONNECTION_STRING)

# Wait for a heartbeat to establish connection
master.wait_heartbeat()
print(f"Heartbeat received from system {master.target_system}, component {master.target_component}")

# Set the target system/component IDs
master.target_system = TARGET_SYSTEM
master.target_component = TARGET_COMPONENT


def request_log_list(start_id, count):
    """
    Sends a LOG_REQUEST_LIST message to the autopilot.
    """
    print(f"\nRequesting log list starting from ID {start_id} for {count} entries...")
    master.mav.log_request_list_send(
        master.target_system,
        master.target_component,
        start_id,  # Start log id
        count  # Logs to get
    )


def get_log_entries():
    """
    Waits for LOG_ENTRY messages and aggregates the list.
    """
    log_entries = []
    log_ids_received = set()  # Use a set to track unique IDs
    total_expected_logs = None  # To store the total number of logs reported
    start_time = time.time()
    TIMEOUT = 10  # seconds

    while time.time() - start_time < TIMEOUT:
        # Check for a LOG_ENTRY message
        # Setting blocking=False and timeout to None means we rely on the loop timeout
        msg = master.recv_match(type='LOG_ENTRY', blocking=False, timeout=0.1)

        if msg:
            # Update the total expected logs count
            if total_expected_logs is None:
                total_expected_logs = msg.num_logs
                print(f"Total expected logs: {total_expected_logs}")

            # Only process if the ID hasn't been seen (handles potential duplicates)
            if msg.id not in log_ids_received:
                log_entries.append(msg)
                log_ids_received.add(msg.id)
                print(f"Received LOG_ENTRY: ID={msg.id}, Size={msg.size} bytes, Time={msg.time_utc}")

            # Check if all expected logs have been received
            if total_expected_logs is not None and len(log_entries) == total_expected_logs:
                print("All expected log entries received.")
                break

        # Check if we have received 'count' logs, which is a sufficient condition
        if total_expected_logs is not None and len(log_entries) == LOGS_COUNT:
            print("Reached the requested count of log entries.")
            break

    return log_entries


# 1. Request the log list
request_log_list(START_LOG_ID, LOGS_COUNT)

# 2. Get the entries
log_list = get_log_entries()

# 3. Print the final list
if log_list:
    print("\n--- Final Log File List ---")
    for log in log_list:
        print(
            f"Log ID: {log.id}, Number of Logs: {log.num_logs}, Size: {log.size} bytes, Time (UTC): {time.ctime(log.time_utc)}")
else:
    print("\nNo log entries received within the timeout.")