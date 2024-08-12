#!/bin/bash

# Variables
LOG_DIR="$HOME/myapp_logs"           # Directory containing logs
ARCHIVE_DIR="$LOG_DIR/archive"       # Directory to store compressed logs
MAX_SIZE="10M"                       # Maximum log size before rotation (e.g., 10M)
RETENTION_DAYS=7                     # Number of days to keep logs
REPORT_FILE="$LOG_DIR/log_report.txt" # Report file

# Create the log and archive directories if they don't exist
mkdir -p "$ARCHIVE_DIR"

# Rotate and compress logs
for LOG_FILE in "$LOG_DIR"/*.log; do
    # Check if any log files are found
    if [ -f "$LOG_FILE" ]; then
        # Check if the log file exceeds the maximum size
        if [ $(stat -c%s "$LOG_FILE") -ge $(echo "$MAX_SIZE" | numfmt --from=iec) ]; then
            TIMESTAMP=$(date +"%Y%m%d%H%M%S")
            ARCHIVE_FILE="$ARCHIVE_DIR/$(basename "$LOG_FILE" .log)_$TIMESTAMP.tar.gz"
            
            # Compress the log file
            tar -czf "$ARCHIVE_FILE" -C "$LOG_DIR" "$(basename "$LOG_FILE")"
            if [ $? -eq 0 ]; then
                # Clear the original log file if compression was successful
                > "$LOG_FILE"
                echo "$(date +"%Y-%m-%d %H:%M:%S") - Rotated and compressed: $LOG_FILE to $ARCHIVE_FILE" >> "$REPORT_FILE"
            else
                echo "$(date +"%Y-%m-%d %H:%M:%S") - Error compressing: $LOG_FILE" >> "$REPORT_FILE"
            fi
        fi
    else
        echo "$(date +"%Y-%m-%d %H:%M:%S") - Log file not found: $LOG_FILE" >> "$REPORT_FILE"
    fi
done

# Delete logs older than retention days
find "$ARCHIVE_DIR" -type f -name "*.tar.gz" -mtime +"$RETENTION_DAYS" -exec rm {} \; -exec echo "$(date +"%Y-%m-%d %H:%M:%S") - Deleted: {}" >> "$REPORT_FILE" \;

# Output report
echo "Log management completed. Report saved to $REPORT_FILE."
