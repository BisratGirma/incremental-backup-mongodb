#!/bin/bash

# MongoDB connection details
HOST="--host"
PORT="--port"
DB="--database_name"

# HOST="localhost"
# PORT="27017"
# DB="dbname"

# the backup directory
BACKUP_DIR="absolute_path_of_backup_folder"

collections=$(mongosh --quiet --host "$HOST" --port "$PORT" --eval "db.getSiblingDB('mineral').getCollectionNames()" | grep -oE "[a-zA-Z0-9_]+" | awk 'BEGIN{ORS=", "} {print "\"" $0 "\""}')

if [ -f "${BACKUP_DIR}last_backup_timestamp.txt" ]; then

    LAST_BACKUP_TIMESTAMP=$(cat "${BACKUP_DIR}last_backup_timestamp.txt")
else

    LAST_BACKUP_TIMESTAMP=$(date -d "Sep 01 2015 00:00:00" +%FT%T%z)
fi

CURRENT_TIMESTAMP=$(date +%FT%T%z)

TEMP_DIR=$(mktemp -d)

# interate over collections dump mongodump to temprary file
for collection in $collections
do

    collection=$(echo "$collection" | tr -d '",')

    # mongodump command for a collection with query and output to a temporary folder
    mongodump --host "$HOST" --port "$PORT" --db "$DB" --collection "$collection" --query "{ \"last_modified\": { \"\$gt\": { \"\$date\": \"$LAST_BACKUP_TIMESTAMP\" } } }" --out "$TEMP_DIR"

done

# move mongodump file to a backup folder
mkdir -p "$BACKUP_DIR$CURRENT_TIMESTAMP" && mv "$TEMP_DIR/$DB" "$BACKUP_DIR$CURRENT_TIMESTAMP"

# Update the last backup timestamp
echo "$CURRENT_TIMESTAMP" > "${BACKUP_DIR}last_backup_timestamp.txt"
