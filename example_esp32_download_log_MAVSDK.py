import asyncio
from mavsdk import System
from mavsdk.log_files import LogFilesError

# --- Configuration ---
# Your component ID (MAVSDK often uses a fixed client component ID,
# but we can try to set the requested target component ID in the future if needed
# for specific messages. For log retrieval, MAVSDK handles this internally).
MY_COMPONENT_ID = 99
# The connection string for listening on UDP port 14550
CONNECTION_ADDRESS = "udpin://0.0.0.0:14550"


async def get_log_files():
    """
    Connects to the flight controller and retrieves the list of log files.
    """
    # 1. Initialize the System object
    drone = System()

    print(f"Connecting to MAVLink system via {CONNECTION_ADDRESS}...")

    # 2. Connect to the flight controller
    await drone.connect(system_address=CONNECTION_ADDRESS)

    # 3. Wait for the flight controller to connect and report its status
    print("Waiting for drone to connect...")
    async for state in drone.core.connection_state():
        if state.is_connected:
            print(f"🎉 Connected to MAVLink system!")
            # Note: MAVSDK handles the target/component IDs for its internal communication.
            # You can confirm the FC's ID once connected.
            break
        await asyncio.sleep(1)

    print("\n--- Requesting Log File List ---")

    try:
        # 4. Request the list of log files
        log_list = await drone.log_files.get_entries()

        if log_list:
            print(f"Found {len(log_list)} log files:")
            print("-" * 50)

            # 5. Display the log file information
            for i, entry in enumerate(log_list):
                # The 'LogEntry' object contains all the details.
                print(
                    f"| {i + 1:02}. ID: {entry.id:<5} | Size: {entry.size_bytes / (1024 * 1024):.2f} MB | Date: {entry.date}")
            print("-" * 50)
        else:
            print("The flight controller reported no log entries.")

    except LogFilesError as e:
        print(f"Error fetching log files: {e}")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")

    print("Log retrieval complete.")


# --- Run the Async Function ---
if __name__ == "__main__":
    try:
        asyncio.run(get_log_files())
    except KeyboardInterrupt:
        print("\nProgram stopped by user.")