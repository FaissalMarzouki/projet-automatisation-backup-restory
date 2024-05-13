#!/bin/bash

restore_dir="/home/faissal/workspace/restore_dir"

remote="backupDrive:"

# Function to restore backup
restore_backup() {
    if [ -z "$1" ]; then
        # Download backup from Google Drive
        rclone copy "$remote" "$restore_dir"

        # Find the latest backup file
        latest_backup=$(ls -t "$restore_dir" | head -n 1)

        # Extract backup to restore directory
        tar -xzvf "$restore_dir/$latest_backup" -C "$restore_dir"

        # Remove downloaded backup file
        rm -f "$restore_dir/$latest_backup"
    else
        # Download backup from Google Drive
        rclone copy "$remote" "$restore_dir" --include "*$1*"

        # Find the backup file for the provided date
        backup_file=$(ls -t "$restore_dir" | grep "$1" | head -n 1)

        # If backup file is found, extract it to restore directory
        if [ -n "$backup_file" ]; then
            tar -xzvf "$restore_dir/$backup_file" -C "$restore_dir"

            echo "Restore completed successfully for backup file $backup_file."
            
            # Clean up downloaded backup
            rm -f "$restore_dir/$backup_file"
        else
            echo "Backup file not found for the provided date: $1"
        fi
    fi
}

# Perform restore
restore_backup "$1"

