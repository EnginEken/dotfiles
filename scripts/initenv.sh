#!/bin/bash
# This script initializes a virtual environment, sets up pyright configuration, and creates a .gitignore file

# Function to print usage
print_usage() {
    echo "Usage: $0 [-p|--project <project_names>]"
    echo "  -p, --project    Project names for gitignore (e.g., python or python,django)"
}

# Initialize variables
PROJECTS=""

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--project)
            PROJECTS="$2"
            shift 2
            ;;
        -h|--help)
            print_usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            print_usage
            exit 1
            ;;
    esac
done

# Create the virtual environment in the .venv directory
uv venv
echo "Virtual environment created in .venv directory"

# Create the pyrightconfig.json file with the specified content
#cat > pyrightconfig.json <<EOL
#{
#  "venvPath": ".",
#  "venv": ".venv"
#}
#EOL
#echo "pyrightconfig.json file created"

# Create .gitignore file if -p or --project option is provided
if [[ -n "$PROJECTS" ]]; then
    RESPONSE=$(curl -s "https://www.toptal.com/developers/gitignore/api/$PROJECTS")
    if [[ $? -eq 0 ]]; then
        echo "$RESPONSE" > .gitignore
        echo ".gitignore file created for projects: $PROJECTS"
    else
        echo "Failed to fetch .gitignore content for projects: $PROJECTS"
    fi
fi

echo "Virtual environment and pyright configuration setup complete."
