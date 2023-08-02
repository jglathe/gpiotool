#!/bin/bash

if ! mount | grep debugfs > /dev/null; then
    sudo mount -t debugfs none /sys/kernel/debug
fi

# watch -n 0.5 sudo cat /sys/kernel/debug/gpio

# File to store the last state
LAST_STATE_FILE="/tmp/last_gpio_state"

# File to store the changes
OUTPUT_FILE="gpio_changes.txt"

# Get the initial state
sudo cat /sys/kernel/debug/gpio > $LAST_STATE_FILE

while true; do
    # Get the current state
    CURRENT_STATE=$(sudo cat /sys/kernel/debug/gpio)

    # Compare with the last state
    if ! diff -q $LAST_STATE_FILE <(echo "$CURRENT_STATE") >/dev/null; then
        # State has changed, record it with a timestamp
        echo "$(date): GPIO state has changed" >> $OUTPUT_FILE
        echo "$CURRENT_STATE" >> $OUTPUT_FILE
        echo "$CURRENT_STATE" > $LAST_STATE_FILE
    fi

    # Wait a little before checking again
    sleep 0.1
done
