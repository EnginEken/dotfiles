#!/bin/bash
# This script activates the appropriate Python virtual environment

if [ -d ".venv/bin" ]; then
    echo "Activating .venv virtual environment"
    source ./.venv/bin/activate
elif [ -d "venv/bin" ]; then
    echo "Activating venv virtual environment"
    source ./venv/bin/activate
else
    echo "No virtual environment found for this project"
fi
