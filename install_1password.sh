#!/bin/bash

# install_1password.sh
# Script to install 1Password and 1Password CLI on Debian/Ubuntu

# Error handling
set -e  # Exit on error
trap 'echo "Error on line $LINENO"' ERR

# Log file setup
LOG_FILE="$HOME/1password_install.log"
exec 1> >(tee -a "$LOG_FILE")
exec 2> >(tee -a "$LOG_FILE" >&2)

echo "Starting 1Password installation at $(date)"
echo "----------------------------------------"

# Function to check command success
check_success() {
    if [ $? -eq 0 ]; then
        echo "✓ $1"
    else
        echo "✗ $1 failed"
        exit 1
    fi
}

# Function to check if package is already installed
is_installed() {
    dpkg -l "$1" &> /dev/null
    return $?
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root or with sudo"
    exit 1
fi

# Install 1Password
echo "Installing 1Password..."

# Add GPG key
echo "Adding 1Password GPG key..."
curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
    gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
check_success "GPG key installation"

# Add repository
echo "Adding 1Password repository..."
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | \
    tee /etc/apt/sources.list.d/1password.list
check_success "Repository addition"

# Add debsig verification policy
echo "Setting up debsig verification..."
mkdir -p /etc/debsig/policies/AC2D62742012EA22/
curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | \
    tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
    gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
check_success "Debsig policy setup"

# Update package list
echo "Updating package list..."
apt update
check_success "Package list update"

# Install 1Password
if ! is_installed "1password"; then
    echo "Installing 1Password application..."
    apt install -y 1password
    check_success "1Password installation"
else
    echo "1Password is already installed"
fi

# Install 1Password CLI
if ! is_installed "1password-cli"; then
    echo "Installing 1Password CLI..."
    apt install -y 1password-cli
    check_success "1Password CLI installation"
else
    echo "1Password CLI is already installed"
fi

# Verify installations
echo "Verifying installations..."
if command -v 1password >/dev/null 2>&1; then
    echo "✓ 1Password is installed"
else
    echo "✗ 1Password installation verification failed"
fi

if command -v op >/dev/null 2>&1; then
    VERSION=$(op --version)
    echo "✓ 1Password CLI is installed (version: $VERSION)"
else
    echo "✗ 1Password CLI installation verification failed"
fi

echo "----------------------------------------"
echo "Installation completed at $(date)"
echo "Log file saved at: $LOG_FILE"