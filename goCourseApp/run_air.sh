#!/bin/bash

# Function to kill process using the port
kill_process_using_port() {
    echo "Checking for process using port 4000..."
    PID=$(lsof -t -i :4008)
    if [ -n "$PID" ]; then
        echo "Found process using port 4000 with PID $PID. Killing it..."
        kill -9 $PID
    else
        echo "No process is using port 4000."
    fi
}

# Start Air in the background
air &

# Get the Air process PID
AIR_PID=$!

# Cleanup function to handle graceful shutdown
cleanup() {
    echo "Cleaning up..."
    kill_process_using_port  # Make sure to kill any process using the port
    kill -SIGINT $AIR_PID    # Terminate the air process
    wait $AIR_PID            # Wait for air to fully terminate
    echo "Air process terminated."
    exit 0
}

# Trap for cleaning up on exit or interrupt signals
trap cleanup EXIT SIGINT SIGTERM

# Wait for Air to run
wait $AIR_PID
