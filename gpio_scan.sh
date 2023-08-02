#!/bin/bash

if ! mount | grep debugfs > /dev/null; then
    sudo mount -t debugfs none /sys/kernel/debug
fi

old_state=$(sudo cat /sys/kernel/debug/gpio)
start_time=$(date +%s%3N)  # Current time in milliseconds

# Print initial states
echo "$old_state"

while true; do
    sleep 0.1
    new_state=$(sudo cat /sys/kernel/debug/gpio)
    
    # Use diff to compare the old and new states
    changes=$(diff <(echo "$old_state") <(echo "$new_state"))
    
    if [ "$changes" != "" ]; then
        # Calculate elapsed time in milliseconds
        current_time=$(date +%s%3N)
        elapsed_time=$(echo "scale=3; ($current_time - $start_time)/1000" | bc)
        
        # Print elapsed time and changes
        echo "${elapsed_time}ms:"
        echo "$changes"
        
        old_state=$new_state
    fi
done
