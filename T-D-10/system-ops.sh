#!/bin/bash

REPORTDIR="/home/einfochips/Desktop/SP/Training/Day10/"
ALERT_THRESHOLD_CPU=75   
ALERT_THRESHOLD_MEM=40  
SERVICE_STATUS=("nginx" "mysql")
EXTERNAL_SERVICES=("google.com" "mysql://db.test.com")

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/")
MEMORY_USAGE=$(free | awk '/Mem/{printf("%.2f"), $3/$2*100}')

System_Metrics() {
    echo -e "\n CPU Usage: "
    echo "CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/")"
    echo "MEMORY_USAGE=$(free | awk '/Mem/{printf("%.2f"), $3/$2*100}')"
    echo "DISK_SPACE=$(df -h / | awk '/\//{print $(NF-1)}')"

    echo -e "\n Network Statistics: "
    echo "NETWORK_STATS=$(netstat -i)"

    echo -e "\n Top Processes: "
    echo "TOP_PROCESSES=$(top -bn 1 | head -n 10)"
}

Log_analysis() {
    echo -e "\Recent Critical Events: "
    echo "CRITICAL_EVENTS=$(tail -n 200 /var/log/syslog | grep -iE 'error|critical')"

    echo -e "\n Recent Logs: "
    echo "RECENT_LOGS=$(tail -n 20 /var/log/syslog)"
}

Health_check() {
    echo -e "\n Service Status: "
    for service in "${SERVICE_STATUS[@]}"; do
        systemctl is-active --quiet "$service"
        if [ $? -eq 0 ]; then
            echo "   $service is running."
        else
            echo "   Alert: $service is not running."
        fi
    done

    echo -e "\n Connectivity Check: "
    for service in "${EXTERNAL_SERVICES[@]}"; do
        ping -c 1 "$service" >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo "   Connectivity to $service is okay." 
        else
            echo "   Alert: Unable to connect to $service."
        fi
    done

}

if (( $(echo "$CPU_USAGE >= $ALERT_THRESHOLD_CPU" | bc -l) )); then
    echo "High CPU Usage Alert: $CPU_USAGE%"
fi

if (( $(echo "$MEMORY_USAGE >= $ALERT_THRESHOLD_MEM" | bc -l) )); then
    echo "High Memory Usage Alert: $MEMORY_USAGE%"
fi


mkdir -p "$REPORTDIR"
REPORTFILE="$REPORTDIR/sysreport_$(date +'%Y-%m-%d_%H-%M-%S').txt"
echo "System Report $(date)" >> "$REPORTFILE"
System_Metrics >> "$REPORTFILE"
Log_analysis>> "$REPORTFILE"
Health_check >> "$REPORTFILE"

echo "Select an option:
1. Check system metrics
2. View logs
3. Check service status
4. Exit"

read choice

case $choice in
    1) System_Metrics
       ;;
    2) Log_analysis
       ;;
    3) Health_check
       ;;
    4) exit ;;
    *) echo "Invalid option";;
esac
