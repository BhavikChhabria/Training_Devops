#!/bin/bash

# Backup PostgreSQL database

# Variables
DB_NAME="{{ db_name }}"
DB_USER="{{ db_user }}"
BACKUP_DIR="{{ backup_dir }}"
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_backup_$(date +'%Y%m%d%H%M%S').sql"

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# Perform the backup
pg_dump -U "$DB_USER" "$DB_NAME" > "$BACKUP_FILE"

# Check if the backup was successful
if [ $? -eq 0 ]; then
  echo "Backup successfully created at $BACKUP_FILE"
else
  echo "Backup failed" >&2
  exit 1
fi
