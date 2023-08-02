#!/bin/bash

if ! mount | grep debugfs > /dev/null; then
    sudo mount -t debugfs none /sys/kernel/debug
fi

old_state=$(sudo cat /sys/kernel/debug/gpio)

# Print initial states
echo "$old_state"

while true; do
    sleep 0.1
    new_state=$(sudo cat /sys/kernel/debug/gpio)

    # Use diff to compare the old and new states
    changes=$(diff <(echo "$old_state") <(echo "$new_state"))

    if [ "$changes" != "" ]; then
        # Calculate elapsed time in seconds
        current_time=$(cat /proc/uptime | cut -d '.' -f1)
        elapsed_time=$current_time

        # Print elapsed time and changes
        echo "${elapsed_time}s:"
        echo "$changes"

        old_state=$new_state
    fi
done
