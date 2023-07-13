#!/bin/bash

# MongoDB connection details
HOST="--host"
PORT="--port"
DB="--database_name"

# Backup directory
BACKUP_DIR="absolute_path_of_the_backup_folder"

TEMP_DIR=$(mktemp -d)

# dump the Mongo database to the temporary directory
mongodump --host "$HOST" --port "$PORT" --db "$DB" --out "$TEMP_DIR"

# Rename the backup file with the current timestamp
CURRENT_TIMESTAMP=$(date +%x%X)
mv "$TEMP_DIR/$DB" "$BACKUP_DIR$CURRENT_TIMESTAMP"

# Update the last backup timestamp
echo "$CURRENT_TIMESTAMP" > "${BACKUP_DIR}last_backup_timestamp.txt"
