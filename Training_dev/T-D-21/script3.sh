#!/bin/bash

# Log file path
LOGFILE="/var/log/script.log"

# Function to log messages
log_message() {
    local message="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $message" >> "$LOGFILE"
}

# Function to check system metrics
check_system_metrics() {
    log_message "Starting system metrics check..."
    if command -v top &> /dev/null; then
        top -bn1 | head -n 20
    else
        log_message "Error: 'top' command not found."
        echo "Error: 'top' command not found."
        return 1
    fi
    log_message "System metrics check completed."
}

# Function to view logs
view_logs() {
    local log_file="$1"
    log_message "Viewing logs from $log_file..."
    if [[ -f "$log_file" ]]; then
        cat "$log_file"
    else
        log_message "Error: Log file $log_file does not exist."
        echo "Error: Log file $log_file does not exist."
        return 1
    fi
}

# Function to check service status
check_service_status() {
    local service_name="$1"
    log_message "Checking status of service $service_name..."
    if systemctl is-active --quiet "$service_name"; then
        echo "$service_name is running."
    else
        log_message "Error: $service_name is not running."
        echo "Error: $service_name is not running."
        return 1
    fi
    log_message "Service status check completed."
}

# Main script logic
main() {
    PS3='Please enter your choice: '
    options=("Check System Metrics" "View Logs" "Check Service Status" "Quit")
    select opt in "${options[@]}"
    do
        case $opt in
            "Check System Metrics")
                check_system_metrics
                ;;
            "View Logs")
                echo -n "Enter log file path: "
                read log_file
                view_logs "$log_file"
                ;;
            "Check Service Status")
                echo -n "Enter service name: "
                read service_name
                check_service_status "$service_name"
                ;;
            "Quit")
                log_message "Script execution completed."
                break
                ;;
            *)
                echo "Invalid option $REPLY."
                ;;
        esac
    done
}

# Execute main function
main
