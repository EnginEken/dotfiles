#!/bin/bash

cpu_usage=$(top -l 1 | grep "CPU usage" | awk '{print $3}')

printf "Cpu: %5s" $cpu_usage
