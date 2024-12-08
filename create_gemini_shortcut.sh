#!/bin/bash

# Install dex (if not already installed)
if ! command -v dex &> /dev/null; then
  sudo apt update
  sudo apt install -y dex
fi

# Create the gemini.desktop file
cat << EOF > ~/Desktop/gemini.desktop
[Desktop Entry]
Name=Gemini
Comment=Access the Gemini Advanced docs
Exec=firefox --new-window https://gemini.google.com/
Icon=firefox
Terminal=false
Type=Application
EOF

# Make the .desktop file executable
chmod +x ~/Desktop/gemini.desktop

echo "Gemini shortcut created on your desktop!"
