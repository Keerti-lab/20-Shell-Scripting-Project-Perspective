#!/bin/bash

# Process name to monitor
process_name="your_process_name_here"

# CPU usage threshold (in percentage)
threshold=50

# Get PID of the process
pid=$(ps aux | grep "$process_name" | grep -v grep | awk '{print $2}')

if [ -z "$pid" ]; then
  echo "Process not found."
else
  # Get current CPU usage of the process
  cpu_usage=$(ps -p "$pid" -o %cpu | awk 'NR>1' | awk -F. '{print $1}') # Extract integer part

  echo "Current CPU usage of $process_name (PID $pid): $cpu_usage%"

  # Compare CPU usage with threshold
  if [ "$cpu_usage" -gt "$threshold" ]; then
    echo "CPU usage exceeds threshold. Terminating process..."
    # Terminate the process
    kill "$pid"
    echo "Process terminated."
  else
    echo "CPU usage within threshold."
  fi
fi