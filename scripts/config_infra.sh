#!/bin/bash
base_path="/Users/eeken/Documents/projects/avanti/shinken/config_infra"
hosts_path="$base_path/hosts"
output_file="system_hosts_and_services.txt"
temp_file="temp_output.txt"
> "$temp_file"

# Loop over each file found in the search
find "$hosts_path" -path "$hosts_path/GH2_HAM" -prune -o -path "$hosts_path/HAM" -prune -o -path "$hosts_path/KON" -prune -o -type f -name "*.disabled" -prune -o -type f -path "*/systems/*" -print | while read -r file; do
    inside_host_block=false
    use_line=""
    host_name=""

    # Read file line by line
    while IFS= read -r line; do
        # Detect the start of the define host block
        if [[ "$line" == "define host {" ]]; then
            inside_host_block=true
        fi

        # Detect the end of the define host block
        if [[ "$line" == "}" ]] && $inside_host_block; then
            inside_host_block=false
        fi

        # If we're inside a define host block, capture the necessary lines
        if $inside_host_block; then
            # Capture the use line
            if [[ "$line" =~ ^[[:space:]]*use[[:space:]]* ]]; then
                use_line=$(echo "$line" | sed 's/^.*use\s*//')
            fi
            # Capture the host_name line
            if [[ "$line" =~ ^[[:space:]]*host_name[[:space:]]* ]]; then
                host_name=$(echo "$line" | awk '{print $2}')
            fi
        fi
    done < "$file"

    # Write the formatted output to the file
    if [[ -n "$use_line" && -n "$host_name" ]]; then
	echo -e "$host_name\t$use_line" >> "$temp_file"
        #printf "%-70s%s\n" "$host_name" "$use_line" >> "$output_file"
    fi
done

column -t -s $'\t' "$temp_file" > "$output_file"
rm "$temp_file"

echo "Output written to $output_file"
