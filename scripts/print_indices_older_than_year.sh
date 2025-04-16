#!/bin/bash

# Define Elasticsearch host
ELASTIC_HOST="https://es-etl.avantiplc.net:9200"

# Get the current date and date one year ago
CURRENT_DATE=$(date +%s)
ONE_YEAR_AGO=$(date -v -1y +%s)

# Get list of indices with their creation dates and filter by prefix etl-usage
INDICES=$(curl --location --request GET "$ELASTIC_HOST/_cat/indices?h=index,creation.date.string" \
  --header 'Content-Type: application/json' \
  --user 'etl_rw:NGqZW9T5aSssu3ea' -d'{}' | awk '$1 ~ /^etl-usage/ {print $1 " " $2}')

# Loop through each index and check if it is older than one year
for INDEX in $INDICES
do
  INDEX_NAME=$(echo $INDEX | awk '{print $1}')
  INDEX_DATE=$(echo $INDEX | awk '{print $2}')
  INDEX_DATE_SECONDS=$(date -j -f "%Y-%m-%dT%H:%M:%S.%NZ" "$INDEX_DATE" +%s)

  if [ "$INDEX_DATE_SECONDS" -lt "$ONE_YEAR_AGO" ]; then
    echo "Index $INDEX_NAME is older than one year (created on $INDEX_DATE). Deleting..."
    
  fi
done
