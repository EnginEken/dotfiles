#!/bin/bash

# Get the system uptime
uptime=$(uptime | cut -d ' ' -f 4- | cut -d ',' -f 1)

# Print the uptime with a fixed width of 10 characters
printf "Up: %5s\n" "$uptime"
