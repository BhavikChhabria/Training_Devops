#!/bin/bash

# Log file paths
SYSTEM_LOGS="/var/log/syslog"
APPLICATION_LOGS="/var/log/application.log"
LOGFILE="/var/log/log_check.log"

# Function to log messages
log_message() {
    local message="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $message" >> "$LOGFILE"
}

# Function to check for out-of-memory issues
check_out_of_memory() {
    log_message "Checking for out-of-memory issues..."
    grep -i "out of memory" "$SYSTEM_LOGS" >> "$LOGFILE"
    if [ $? -eq 0 ]; then
        echo "Out-of-memory issues found in system logs."
        log_message "Out-of-memory issues found in system logs."
    else
        echo "No out-of-memory issues found."
    fi
}

# Function to check for failed service starts
check_failed_service_starts() {
    log_message "Checking for failed service starts..."
    grep -i "failed to start" "$SYSTEM_LOGS" >> "$LOGFILE"
    if [ $? -eq 0 ]; then
        echo "Failed service starts found in system logs."
        log_message "Failed service starts found in system logs."
    else
        echo "No failed service starts found."
    fi
}

# Function to check for common application errors
check_application_errors() {
    log_message "Checking for common application errors..."
    grep -i "error" "$APPLICATION_LOGS" >> "$LOGFILE"
    if [ $? -eq 0 ]; then
        echo "Application errors found in application logs."
        log_message "Application errors found in application logs."
    else
        echo "No application errors found."
    fi
}

# Function to provide troubleshooting steps
provide_troubleshooting_guide() {
    log_message "Providing troubleshooting guide..."
    echo "Troubleshooting Guide:" > "$LOGFILE"
    echo "1. **Out-of-Memory Issues**" >> "$LOGFILE"
    echo "   - Check system memory usage using 'free -h' or 'top'." >> "$LOGFILE"
    echo "   - Consider adding more RAM or optimizing memory usage." >> "$LOGFILE"
    echo "2. **Failed Service Starts**" >> "$LOGFILE"
    echo "   - Check the service status using 'systemctl status <service>'." >> "$LOGFILE"
    echo "   - Review service configuration files and logs for errors." >> "$LOGFILE"
    echo "3. **Application Errors**" >> "$LOGFILE"
    echo "   - Check application configuration and error logs for specific error messages." >> "$LOGFILE"
    echo "   - Review application documentation for troubleshooting tips." >> "$LOGFILE"
}

# Main script logic
main() {
    log_message "Starting log check and troubleshooting..."

    check_out_of_memory
    check_failed_service_starts
    check_application_errors
    provide_troubleshooting_guide

    log_message "Log check and troubleshooting completed."
}

# Execute main function
main
