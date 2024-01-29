#!/bin/bash

# Start noVNC
/usr/share/novnc/utils/launch.sh --listen 8080 &

# Start x11vnc
x11vnc -display :1 -rfbport 5901 -noxdamage -forever -bg -nopw

# Start Mate desktop
mate-session
