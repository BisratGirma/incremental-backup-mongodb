#!/bin/bash

# MongoDB connection details
HOST="localhost"
PORT="27017"
DB="mineral"

# Backup directory
BACKUP_DIR="/home/elst/Documents/practice/scripts/backups/"

TEMP_DIR=$(mktemp -d)

# dump mongo database to temporary directory
mongodump --host "$HOST" --port "$PORT" --db "$DB" --out "$TEMP_DIR"

# Rename the backup file with the current timestamp
CURRENT_TIMESTAMP=$(date +%x%X)
mv "$TEMP_DIR/$DB" "$BACKUP_DIR$CURRENT_TIMESTAMP"

# Update the last backup timestamp
echo "$CURRENT_TIMESTAMP" > "${BACKUP_DIR}last_backup_timestamp.txt"
