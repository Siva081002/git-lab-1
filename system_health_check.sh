#!/bin/bash

# Set the date string
DATE=$(date +%F)

# 1. Log all running processes
ps aux > process_log_$DATE.log
echo "Running processes logged to process_log_$DATE.log"
echo

# 2. Check for high memory usage
high_mem=$(ps aux | awk '$4>30')
high_mem_count=$(ps aux | awk '$4>30' | wc -l)

if [ "$high_mem_count" -gt 0 ]; then
    echo "WARNING: Processes using more than 30% memory found!"
    echo "$high_mem" >> high_mem_processes.log
    echo
fi

# 3. Check disk space on root
usage=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
if [ "$usage" -gt 80 ]; then
    echo "WARNING: Disk usage on / is $usage%!"
    echo
fi

# 4. Display summary
total=$(ps -e --no-headers | wc -l)
echo "---- Summary ----"
echo "Total running processes: $total"
echo "Processes using >30% memory: $high_mem_count"
echo "Disk usage on / : $usage%"