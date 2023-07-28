#!/bin/bash

sudo apt-get update -y
# sudo apt-get upgrade -y

sudo apt install -y avahi-daemon

## For japanese
sudo timedatectl set-timezone Asia/Tokyo
sudo cat << 'EOF' | sudo tee /etc/default/keyboard
# KEYBOARD CONFIGURATION FILE

# Consult the keyboard(5) manual page.

XKBMODEL="pc105"
XKBLAYOUT="jp"
XKBVARIANT=""
XKBOPTIONS=""

BACKSPACE="guess"
EOF