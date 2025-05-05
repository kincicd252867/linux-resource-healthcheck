#!/bin/bash

# Resources thresholds
MEM_THRESHOLD=20

# Email settings
RECIPIENT="riekin2024@gmail.com"
MEM_SUBJECT="Memory resource usage alert"

# Functions to get memory usage
get_mem_usage() {
    MEM_USAGE=$(free -m | grep Mem | awk '{print ($3/$2)*100}')
    echo $MEM_USAGE
}

# Main script logic
MEM_USAGE=$(get_mem_usage)

ALERT=false
MESSAGE=""

# Check Memory usage
if (( $(echo "$MEM_USAGE > $MEM_THRESHOLD" | bc -l) )); then
    ALERT=true
    MESSAGE+="Memory usage is ${MEM_USAGE}% (threshold: ${MEM_THRESHOLD}%)\n"
    SUBJECT=$MEM_SUBJECT  # Set subject for Memory alert
fi

# Send alert to email recipient using the appropriate subject.    
if [ "$ALERT" = true ]; then
    echo -e "$MESSAGE" | mail -s "$SUBJECT" "$RECIPIENT"
fi