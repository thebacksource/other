#!/bin/bash

# Setup script for Remote Desktop App on Kali Linux
# This script installs Python, required packages, and FFmpeg
# Run with: sudo bash setup.sh

set -e  # Exit on any error

echo "=== Remote Desktop App Setup for Kali Linux ==="
echo "This script will install Python 3.11+, pip packages, and FFmpeg."
echo "Run as root (sudo) for system-wide installation."
echo

# Update system packages
echo "Updating system packages..."
apt update -y
apt upgrade -y

# Install Python 3.11+ and pip
echo "Installing Python 3.11+ and pip..."
apt install -y python3.11 python3.11-venv python3.11-dev python3-pip

# Verify Python installation
if ! command -v python3 &> /dev/null; then
    echo "Python3 not found after installation. Please install manually."
    exit 1
fi

PYTHON_VERSION=$(python3 --version)
echo "Python version: $PYTHON_VERSION"

# Upgrade pip
echo "Upgrading pip..."
python3 -m pip install --upgrade pip

# Install required Python packages
echo "Installing Python packages: aiohttp, aiortc, websockets, psutil, pyautogui..."
python3 -m pip install --user aiohttp aiortc websockets psutil pyautogui

# For pyautogui on Linux, install additional dependencies
echo "Installing pyautogui dependencies for Linux..."
apt install -y scrot x11-utils python3-tk python3-dev

# Install FFmpeg
echo "Installing FFmpeg..."
apt install -y ffmpeg

# Verify FFmpeg installation
if ! command -v ffmpeg &> /dev/null; then
    echo "FFmpeg not found after installation. Please install manually."
    exit 1
fi

FFMPEG_VERSION=$(ffmpeg -version | head -n1)
echo "FFmpeg version: $FFMPEG_VERSION"

# Create a virtual environment (optional, but recommended)
echo "Creating virtual environment (optional)..."
python3 -m venv remote_desktop_env

# Activate virtual environment and install packages
if [ -d "remote_desktop_env" ]; then
    source remote_desktop_env/bin/activate
    pip install --upgrade pip
    pip install aiohttp aiortc websockets psutil pyautogui
    echo "Virtual environment created and packages installed."
    echo "To use: source remote_desktop_env/bin/activate"
else
    echo "Virtual environment creation failed."
fi

echo
echo "=== Setup Complete! ==="
echo "All dependencies installed successfully."
echo
echo "To run the application:"
echo "1. Save the remote_desktop.py script in this directory"
echo "2. Run: python3 remote_desktop.py"
echo
echo "If using virtual environment:"
echo "1. source remote_desktop_env/bin/activate"
echo "2. python remote_desktop.py"
echo
echo "Note: For screen capture on Kali Linux, you may need to:"
echo "- Run X11 forwarding if using SSH: ssh -X user@host"
echo "- Ensure display is set: export DISPLAY=:0"
echo "- Grant permissions for screen capture if needed"
echo
echo "Test installations:"
echo "  python3 --version"
echo "  pip3 list | grep -E '(aiohttp|aiortc|websockets|psutil|pyautogui)'"
echo "  ffmpeg -version"
echo
read -p "Press Enter to exit..."
