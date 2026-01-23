#!/usr/bin/env python3
"""
Simple test script to verify DBLogger singleton works correctly.
"""
import unittest
import os
from datetime import datetime
from DroneBridgeCommercialSupportSuite import DBLogger

class LoggerTestCase(unittest.TestCase):
    def test_basic_logger(self):
        # Create a test log file
        log_dir = "test_logs"

        desired_log_entries = ["logfile init done!",
                               "Test 1: Logging from main script",
                               "Test 2: Logging from 'second' instance (should be same singleton)",
                               "Test 3: All tests completed"]

        # Initialize the singleton logger
        logger = DBLogger()
        logfile_path = logger.create_log_file(log_dir)
        logger.log(desired_log_entries[0])
        self.assertEqual(os.path.exists(logfile_path), True, msg="Check if a log file was actually created")

        # Test 1: Log from main script
        logger.log(desired_log_entries[1])

        # Test 2: Create another instance and verify it's the same
        logger2 = DBLogger()
        logger2.log(desired_log_entries[2])

        # Test 4: Verify log file was created and contains all messages
        logger.log(desired_log_entries[3])

        # Display the log file contents
        if os.path.exists(logfile_path):
            with open(logfile_path, 'r') as f:
                for expected_entry in desired_log_entries:
                    line = f.readline()
                    self.assertEqual(line.endswith(expected_entry + '\n'), True, msg=f"Check if log file contains message: {expected_entry}")



if __name__ == '__main__':
    unittest.main()