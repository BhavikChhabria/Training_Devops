#!/bin/bash

# Initialization
initialize() {
    # Variables
    LOG_FILE="/var/log/sysops_monitor.log"
    REPORT_FILE="/var/log/sysops_report.txt"
    EMAIL="sysadmin@example.com"
    
    # Check for required commands
    for cmd in vmstat iostat top awk grep systemctl mail; do
        if ! command -v $cmd &> /dev/null; then
            echo "Error: $cmd is not installed." | tee -a $LOG_FILE
            exit 1
        fi
    done
}

# System Metrics Collection
collect_metrics() {
    echo "Collecting system metrics..." | tee -a $LOG_FILE
    echo "=== System Metrics ===" > $REPORT_FILE

    # CPU usage
    echo "CPU Usage:" >> $REPORT_FILE
    vmstat 1 5 | awk 'NR>2 {print $13}' | tee -a $REPORT_FILE

    # Memory utilization
    echo "Memory Utilization:" >> $REPORT_FILE
    free -m | awk 'NR==2 {printf "Memory Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }' | tee -a $REPORT_FILE

    # Disk space
    echo "Disk Space Usage:" >> $REPORT_FILE
    df -h | grep -E '^/dev/' | awk '{ print $1 " " $5 " used of " $2 }' | tee -a $REPORT_FILE

    # Network statistics
    echo "Network Statistics:" >> $REPORT_FILE
    iostat -c | grep -A 2 avg-cpu | tee -a $REPORT_FILE

    # Top processes
    echo "Top Processes:" >> $REPORT_FILE
    top -b -n1 | head -n 20 | tee -a $REPORT_FILE
}

# Log Analysis
analyze_logs() {
    echo "Analyzing logs..." | tee -a $LOG_FILE
    echo "=== Log Analysis ===" >> $REPORT_FILE

    # Parse syslog
    echo "Critical Events in Syslog:" >> $REPORT_FILE
    grep -i "crit\|error" /var/log/syslog | tail -n 20 | tee -a $REPORT_FILE
}

# Health Checks
health_checks() {
    echo "Performing health checks..." | tee -a $LOG_FILE
    echo "=== Health Checks ===" >> $REPORT_FILE

    # Check essential services
    for service in apache2 mysql; do
        systemctl is-active --quiet $service && status="Running" || status="Stopped"
        echo "$service status: $status" | tee -a $REPORT_FILE
    done

    # Verify connectivity
    echo "Checking connectivity to external services..." >> $REPORT_FILE
    ping -c 4 google.com &> /dev/null && echo "Internet connectivity: OK" | tee -a $REPORT_FILE || echo "Internet connectivity: Failed" | tee -a $REPORT_FILE
}

# Alerting Mechanism
send_alerts() {
    echo "Checking for alerts..." | tee -a $LOG_FILE

    # CPU threshold
    cpu_usage=$(vmstat 1 5 | awk 'NR>2 {sum+=$13} END {print sum/NR}')
    if (( $(echo "$cpu_usage > 80" |bc -l) )); then
        echo "Alert: CPU usage is high: $cpu_usage%" | tee -a $LOG_FILE
        echo "CPU usage is high: $cpu_usage%" | mail -s "High CPU Usage Alert" $EMAIL
    fi

    # Memory threshold
    memory_usage=$(free -m | awk 'NR==2 {print $3*100/$2}')
    if (( $(echo "$memory_usage > 80" |bc -l) )); then
        echo "Alert: Memory usage is high: $memory_usage%" | tee -a $LOG_FILE
        echo "Memory usage is high: $memory_usage%" | mail -s "High Memory Usage Alert" $EMAIL
    fi
}

# Report Generation
generate_report() {
    echo "Generating report..." | tee -a $LOG_FILE
    cat $REPORT_FILE | mail -s "System Monitoring Report" $EMAIL
}

# Automation and Scheduling
schedule_script() {
    echo "Scheduling script via cron..." | tee -a $LOG_FILE
    (crontab -l 2>/dev/null; echo "*/5 * * * * /path/to/this_script.sh") | crontab -
}

# User Interaction
interactive_mode() {
    PS3='Please enter your choice: '
    options=("Collect Metrics" "Analyze Logs" "Health Checks" "Send Alerts" "Generate Report" "Quit")
    select opt in "${options[@]}"
    do
        case $opt in
            "Collect Metrics")
                collect_metrics
                ;;
            "Analyze Logs")
                analyze_logs
                ;;
            "Health Checks")
                health_checks
                ;;
            "Send Alerts")
                send_alerts
                ;;
            "Generate Report")
                generate_report
                ;;
            "Quit")
                break
                ;;
            *) echo "invalid option $REPLY";;
        esac
    done
}

# Documentation
create_readme() {
    cat <<EOF > README.md
# SysOps Monitoring Script

## Usage

### Prerequisites
- Ensure the following commands are available: vmstat, iostat, top, awk, grep, systemctl, mail.

### Execution
Run the script using:
\`\`\`
./sysops_monitor.sh
\`\`\`

### Customization
- Edit variables at the top of the script for email notifications, log file paths, etc.

### Scheduling
- The script can be scheduled to run periodically using cron.

### Example Outputs
- Detailed report will be sent via email.
- Alerts will be triggered based on predefined thresholds.

EOF
}

# Main Execution
initialize
interactive_mode
create_readme

# Uncomment the following line to schedule the script via cron
# schedule_script

