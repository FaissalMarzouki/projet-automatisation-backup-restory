#!/bin/bash

# Backup directory
backup_dir="/home/faissal/workspace/backup_dir"

# Google Drive remote name configured in rclone
remote="backupDrive:"

# Function to perform backup
backup_files() {
    # Create backup directory if it doesn't exist
    mkdir -p "$backup_dir"

    # Create backup archive
    timestamp=$(date +%Y%m%d_%H%M%S)
    backup_filename="backup_$timestamp.tar.gz"
    sudo tar -czf "$backup_dir/$backup_filename" /etc/passwd /etc/group /etc/shadow /etc/sudoers

    # Upload backup to Google Drive
    rclone copy "$backup_dir/$backup_filename" "$remote"
}

# Perform backup
backup_files
echo "Backup completed successfully."

