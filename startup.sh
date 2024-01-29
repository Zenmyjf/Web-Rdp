#!/bin/bash

# Set a password for noVNC
mkdir -p ~/.vnc
echo "your_password" | vncpasswd -f > ~/.vnc/passwd

# Start Mate desktop
mate-session &

# Start x11vnc
x11vnc -display :1 -rfbport 5901 -noxdamage -forever -bg -usepw

# Start noVNC with password authentication
websockify -D --web /usr/share/novnc/ --cert /etc/ssl/novnc.pem 6080 localhost:5901
