#!/bin/bash

# Log the steps for debugging
echo "Starting MkDocs service" >> /tmp/mkdocs_debug.log
source /Users/eeken/Documents/projects/personal/books-mkdocs/.venv/bin/activate 2>> /tmp/mkdocs_debug.log

# Navigate to the MkDocs project directory
cd /Users/eeken/Documents/projects/personal/books-mkdocs 2>> /tmp/mkdocs_debug.log

# Start MkDocs server with nohup and log output
nohup mkdocs serve -a 0.0.0.0:8000 > /tmp/mkdocs_output.log 2>&1 &
echo "MkDocs service started" >> /tmp/mkdocs_debug.log
