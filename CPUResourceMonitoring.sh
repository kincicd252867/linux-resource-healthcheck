#!/bin/bash

# Resources thresholds
CPU_THRESHOLD=20

# Email settings
RECIPIENT="riekin2024@gmail.com"
SUBJECT="CPU resource usage alert"

# Functions to get CPU usage
get_cpu_usage() {
    CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/")
    CPU_USAGE=$(echo "100 - $CPU_IDLE" | bc)
    echo $CPU_USAGE 
}

# Main script logic
CPU_USAGE=$(get_cpu_usage)

ALERT=false
MESSAGE=""

# Check CPU usage
if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
    ALERT=true
    MESSAGE+="CPU usage is ${CPU_USAGE}% (threshold: ${CPU_THRESHOLD}%)\n"
fi

# Send alert to email recipient using the appropriate subject.    
if [ "$ALERT" = true ]; then
    echo -e "$MESSAGE" | mail -s "$SUBJECT" "$RECIPIENT"
fi