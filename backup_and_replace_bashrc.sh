#!/bin/bash

# backup_and_replace_bashrc.sh
# Script to replace ~/.bashrc with ./Projects/LinuxConfig/.bashrc

# Define paths
SOURCE="$HOME/Projects/LinuxConfig/.bashrc"
DESTINATION="$HOME/.bashrc"
BACKUP="$HOME/.bashrc.backup.$(date +%Y%m%d_%H%M%S)"

# Check if source file exists
if [ ! -f "$SOURCE" ]; then
    echo "Error: Source file $SOURCE not found"
    exit 1
fi

# Create backup of current .bashrc if it exists
if [ -f "$DESTINATION" ]; then
    echo "Creating backup of current .bashrc..."
    cp "$DESTINATION" "$BACKUP"
    echo "Backup created at: $BACKUP"
fi

# Copy new .bashrc
echo "Copying new .bashrc..."
cp "$SOURCE" "$DESTINATION"

# Set correct permissions
chmod 644 "$DESTINATION"

# Source the new .bashrc
echo "Reloading .bashrc..."
source "$DESTINATION"

echo "Done! New .bashrc is now in place."