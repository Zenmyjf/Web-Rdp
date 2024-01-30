#!/bin/bash

# Start Xvfb
Xvfb :1 -screen 0 1024x768x16 &

# Start Fluxbox window manager
fluxbox &

# Start noVNC
x11vnc -display :1 -nopw -listen 0.0.0.0 -forever &

# Launch Firefox
firefox --display=:1

# Keep the container running
tail -f /dev/null
