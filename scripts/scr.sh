#!/bin/bash

# Function to test authentication
test_auth() {
    echo "Testing authentication..."
    response=$(curl -s -X GET "${SNOW_BASE_URL}/now/table/sys_user?sysparm_limit=1" \
        --header "Accept:application/json" \
        --header "Content-Type: application/json" \
        --user "$SNOW_USER:$SNOW_PWD")
    
    if echo "$response" | jq -e '.error' >/dev/null 2>&1; then
        echo "ERROR: Authentication failed"
        echo "Response: $response"
        return 1
    fi
    
    echo "Authentication successful"
    return 0
}

# Function to send requests using curl
send_request() {
    local method=$1
    local url=$2
    local data=$3
    
    if [ ! -z "$data" ]; then
        echo "DEBUG: Request data: $data" >&2
    fi
    
    # Make the request
    curl -s -X "$method" "$url" \
        --header "Accept:application/json" \
        --header "Content-Type: application/json" \
        --data "$data" \
        --user "$SNOW_USER:$SNOW_PWD"
    
    return $?
}

# Function to create a standard change
create_standard_change() {
    local start_date=$1
    local end_date=$2

    echo "DEBUG: Creating standard change with start_date=$start_date and end_date=$end_date" >&2
    echo "DEBUG: Using template ID: $SHINKEN_CRUD_TEMPLATE_ID" >&2
    
    # Create the change using the standard change API
    data=$(cat <<EOF
{
    "template": "${SHINKEN_CRUD_TEMPLATE_ID}",
    "start_date": "$start_date",
    "end_date": "$end_date",
    "type": "standard",
    "short_description": "Automated Standard Change",
    "category": "standard",
    "impact": "3",
    "priority": "3",
    "risk": "3"
}
EOF
)

    echo "DEBUG: Creating change request..." >&2
    
    response=$(send_request "POST" "${SNOW_BASE_URL}/sn_chg_rest/change/standard/${SHINKEN_CRUD_TEMPLATE_ID}" "$data")
    local status=$?
    
    if [ $status -ne 0 ]; then
        echo "ERROR: Failed to create change" >&2
        return 1
    fi
    
    # Validate JSON response
    if ! echo "$response" | jq . >/dev/null 2>&1; then
        echo "ERROR: Invalid JSON response" >&2
        echo "Response: $response" >&2
        return 1
    fi
    
    # Check if we got a result object in the response
    if ! echo "$response" | jq -e '.result' > /dev/null; then
        echo "ERROR: Invalid response format, no result object" >&2
        echo "Response: $response" >&2
        return 1
    fi
    
    echo "$response"
    return 0
}

# Function to update change state
update_change_state() {
    local change_id=$1
    local state=$2

    if [ "$state" -eq 3 ]; then
        data=$(cat <<EOF
{ "state": "$state", "close_code": "Successful", "close_notes": "Successfully implemented." }
EOF
)
    else
        data=$(cat <<EOF
{ "state": "$state" }
EOF
)
    fi

    response=$(send_request "PATCH" "${SNOW_BASE_URL}${SNOW_STANDARD_CHG_PATH}${change_id}" "$data")
    echo "$response"
}

# Function to get the user ID
get_user_id_from_email() {
    echo "DEBUG: Getting user ID for email: $SNOW_USER_EMAIL" >&2
    response=$(send_request "GET" "${SNOW_BASE_URL}${SNOW_USER_PATH}?sysparm_query=user_email=${SNOW_USER_EMAIL}&sysparm_fields=sys_id&sysparm_limit=1" "")
    echo "DEBUG: User lookup response: $response" >&2
    
    # Extract just the sys_id value
    user_id=$(echo "$response" | jq -r '.result[0].sys_id')
    if [ -z "$user_id" ] || [ "$user_id" = "null" ]; then
        echo "ERROR: Could not extract user ID from response" >&2
        return 1
    fi
    echo "DEBUG: Extracted user_id: $user_id" >&2
    printf "%s" "$user_id"
}

# Function to assign the ticket to a user
assign_ticket_to_user() {
    local change_id=$1
    local user_id=$2

    echo "DEBUG: Attempting to assign change $change_id to user $user_id" >&2
    
    data=$(cat <<EOF
{
    "assigned_to": "$user_id",
    "assignment_group": "34d786014785f55064c61702e26d43f8"
}
EOF
)

    echo "DEBUG: Assignment request payload: $data" >&2
    
    # Use the table API endpoint for updating the change request
    update_url="${SNOW_BASE_URL}/now/table/change_request/$change_id"
    echo "DEBUG: Assignment URL: $update_url" >&2
    
    response=$(send_request "PATCH" "$update_url" "$data")
    local status=$?
    
    echo "DEBUG: Assignment response status: $status" >&2
    echo "DEBUG: Raw assignment response: $response" >&2
    
    # Check if the response contains an error
    if echo "$response" | jq -e '.error' > /dev/null; then
        echo "ERROR: Assignment failed with error: $(echo "$response" | jq -r '.error.message')" >&2
        return 1
    fi
    
    # Verify the assignment was successful by checking the result
    if ! echo "$response" | jq -e '.result' > /dev/null; then
        echo "ERROR: Invalid response format, no result object" >&2
        return 1
    fi
    
    assigned_to=$(echo "$response" | jq -r '.result.assigned_to.value')
    echo "DEBUG: Verified assigned_to value: $assigned_to" >&2
    
    if [ -z "$assigned_to" ] || [ "$assigned_to" = "null" ]; then
        echo "ERROR: Assignment verification failed. assigned_to field is empty or null" >&2
        return 1
    fi
    
    if [ "$assigned_to" != "$user_id" ]; then
        echo "ERROR: Assignment verification failed. Expected user $user_id but got $assigned_to" >&2
        return 1
    fi
    
    echo "$response"
    return 0
}

# Main script execution
# Test authentication first
if ! test_auth; then
    echo "Authentication test failed. Exiting..." >&2
    exit 1
fi

# 1 hour before because of the time zone difference with ServiceNow
now=$(date -v-1H +'%Y-%m-%d %H:%M:%S')
end_time=$(date +'%Y-%m-%d %H:%M:%S')

echo "DEBUG: Creating standard change..." >&2
create_response=$(create_standard_change "$now" "$end_time")
create_status=$?

if [ $create_status -ne 0 ]; then
    echo "ERROR: Failed to create change" >&2
    exit 1
fi

# Extract the sys_id and number from the response
change_id=$(echo "$create_response" | jq -r '.result.sys_id.value')
change_number=$(echo "$create_response" | jq -r '.result.number.value')

echo "DEBUG: Extracted change_id: $change_id" >&2
echo "DEBUG: Extracted change_number: $change_number" >&2

if [ -z "$change_id" ] || [ "$change_id" = "null" ]; then
    echo "ERROR: Could not extract change ID from response" >&2
    echo "Response: $create_response" >&2
    exit 1
fi

echo "Change created successfully. Change Number: $change_number" >&2
echo "$change_id" > created_ticket_id

# Get the user ID from email
echo "DEBUG: Getting user ID..." >&2
user_id=$(get_user_id_from_email)
user_status=$?
if [ $user_status -ne 0 ] || [ -z "$user_id" ] || [ "$user_id" = "null" ]; then
    echo "ERROR: Could not get user ID" >&2
    exit 1
fi
echo "DEBUG: Retrieved user_id: $user_id" >&2

# Assign the ticket to the user
echo "DEBUG: Assigning ticket to user..." >&2
assign_response=$(assign_ticket_to_user "$change_id" "$user_id")
assign_status=$?

if [ $assign_status -ne 0 ]; then
    echo "ERROR: Failed to assign ticket" >&2
    echo "Response: $assign_response" >&2
    exit 1
fi

echo "Ticket successfully assigned to user ID: $user_id" >&2

# Update the change state
state_change_response=$(update_change_state "$change_id" "-1")
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to update state"
    echo "Response: $state_change_response"
    exit 1
fi

new_state=$(echo "$state_change_response" | jq -r '.result.state.display_value')
echo "State changed successfully. New State: $new_state"
