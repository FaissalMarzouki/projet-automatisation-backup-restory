#!/bin/bash

backup_dir="/home/faissal/workspace/backup_dir"

# Google Drive remote name configured in rclone
remote="backupDrive:"

# Function to perform backup
backup_files() {
    mkdir -p "$backup_dir"

    # Create backup archive
    timestamp=$(date +%Y%m%d_%H%M%S)
    backup_filename="backup_$timestamp.tar.gz"

    # Include /etc files
    tar_args="/etc/passwd /etc/group /etc/shadow"

    if [ -n "$1" ]; then
        tar_args+=" $1"
    fi

    # Create backup archive
    tar -czf "$backup_dir/$backup_filename" $tar_args

    # Upload backup to Google Drive
    rclone copy "$backup_dir/$backup_filename" "$remote"
}

# Check if a parameter is provided
if [ $# -gt 0 ]; then
    backup_files "$1"
else
    backup_files
fi

echo "Backup completed successfully."

