#!/bin/bash

# Resources thresholds
DISK_THRESHOLD=20

# Email settings
RECIPIENT="riekin2024@gmail.com"
DISK_SUBJECT="Disk resource usage alert"

# Functions to get disk usage percentage and mount point for each fs.
get_disk_usage() {
    df -h | awk 'NR>1 {print $5, $6}'
}

DISK_USAGE=$(get_disk_usage)

ALERT=false
MESSAGE=""

# Check Disk usage
if (( $(echo "$DISK_USAGE > $DISK_THRESHOLD" | bc -l) )); then
    ALERT=true
    MESSAGE+="Disk usage is ${DISK_USAGE}% (threshold: ${DISK_THRESHOLD}%)\n"
    SUBJECT=$DISK_SUBJECT  # Set subject for Disk alert
fi

# Check disk usage for each fs.
while read -r line; do
    USE_PERCENT=$(echo "$line" | awk '{print $1}' | sed 's/%//')
    MOUNT_POINT=$(echo "$line" | awk '{print $2}')
    if [ "$USE_PERCENT" -gt "$DISK_THRESHOLD" ]; then
        ALERT=true
        MESSAGE+="Disk usage on ${MOUNT_POINT} is ${USE_PERCENT}% (threshold: ${DISK_THRESHOLD}%)\n"
        SUBJECT=$DISK_SUBJECT  # Set subject for Disk alert
    fi
done <<< "$DISK_USAGE"

# Send alert to email recipient using the appropriate subject.    
if [ "$ALERT" = true ]; then
    echo -e "$MESSAGE" | mail -s "$SUBJECT" "$RECIPIENT"
fi