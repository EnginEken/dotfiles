#!/bin/bash

# Function to send requests using curl
send_request() {
    local method=$1
    local url=$2
    local data=$3
    response=$(curl "$url" \
	--silent \
        --request "$method" \
        --header "Accept:application/json" \
        --header "Content-Type: application/json" \
        --data "$data" \
        --user "$SNOW_USER:$SNOW_PWD")

    # Check if curl request was successful
    if [ $? -ne 0 ]; then
        echo "HTTP request failed"
        exit 1
    fi

    echo "$response"
}

# Function to create a standard change
create_standard_change() {
    local start_date=$1
    local end_date=$2

    data=$(cat <<EOF
{"start_date": "$start_date","end_date": "$end_date"}
EOF
)

    response=$(send_request "POST" "${SNOW_BASE_URL}${SNOW_STANDARD_CHG_PATH}${SHINKEN_CRUD_TEMPLATE_ID}" "$data")
    echo "$response"
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

# Function to assign the ticket to a user
assign_ticket_to_user() {
    local change_id=$1
    local user_id=$2

    data=$(cat <<EOF
{ "assigned_to": "$user_id" }
EOF
)

    response=$(send_request "PATCH" "${SNOW_BASE_URL}${SNOW_STANDARD_CHG_PATH}${change_id}" "$data")
    echo "$response"
}

# Function to get the user ID
get_user_id_from_email() {
    response=$(send_request "GET" "${SNOW_BASE_URL}${SNOW_USER_PATH}?sysparm_query=user_email=${SNOW_USER_EMAIL}&sysparm_fields=sys_id&sysparm_limit=1" "")
    user_id=$(echo "$response" | jq -r '.result[0].sys_id')
    echo "$user_id"
}

# Function to get the user ID
# get_user_id() {
#     local user_name=$1

#     response=$(send_request "GET" "${SNOW_BASE_URL}user?sysparm_query=name%20%3D%20%22$user_name%22" "")
#     user_id=$(echo "$response" | jq -r '.result[0].sys_id.value')
#     echo "$user_id"
# }

# # Function to get the change ID
# get_change_id() {
#     local change_number=$1

#     response=$(send_request "GET" "${SNOW_BASE_URL}change?sysparm_query=number%20%3D%20%22$change_number%22" "")
#     change_id=$(echo "$response" | jq -r '.result[0].sys_id.value')
#     echo "$change_id"
# }

# # Function to get the template ID
# get_template_id() {
#     local template_name=$1

#     response=$(send_request "GET" "${SNOW_BASE_URL}change_template?sysparm_query=name%20%3D%20%22$template_name%22" "")
#     template_id=$(echo "$response" | jq -r '.result[0].sys_id.value')
#     echo "$template_id"
# }



# Main script execution
# 1 hour before because of the time zone difference with ServiceNow
now=$(date -v-1H +'%Y-%m-%d %H:%M:%S')
end_time=$(date +'%Y-%m-%d %H:%M:%S')

# Create a standard change
create_response=$(create_standard_change "$now" "$end_time")
change_id=$(echo "$create_response" | jq -r '.result.sys_id.value')
change_number=$(echo "$create_response" | jq -r '.result.number.value')

if [ -z "$change_id" ]; then
    echo "Change could not be created. Exiting..."
    exit 1
fi

echo "Change created successfully. Change Number: $change_number"
echo "$change_id" > created_ticket_id

user_id=$(get_user_id_from_email)
echo "User ID: $user_id"
# Assign the ticket to a user
assign_response=$(assign_ticket_to_user "$change_id", "$user_id")
if [ -z "$assign_response" ]; then
    echo "Ticket could not be assigned. Exiting..."
    exit 1
fi
echo "Ticket successfully assigned."

# Update the change state
state_change_response=$(update_change_state "$change_id" "-1")
if [ -z "$state_change_response" ]; then
    echo "State could not be changed. Exiting..."
    exit 1
fi
new_state=$(echo "$state_change_response" | jq -r '.result.state.display_value')
echo "State changed successfully. New State: $new_state"
