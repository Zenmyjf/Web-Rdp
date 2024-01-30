
# Use a minimal base image
FROM ubuntu:20.04

# Set the keyboard origin environment variable to avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true
ENV KEYBOARD_ORIGIN=us

# Update packages and install necessary components including noVNC and a lightweight browser
RUN apt-get update && apt-get install -y \
    --no-install-recommends \
    x11vnc \
    novnc \
    fluxbox \
    firefox-esr \
    && apt-get clean

# Expose the VNC port
EXPOSE 6080

# Start noVNC with a lightweight window manager and browser
CMD bash -c "Xvfb :1 -screen 0 1024x768x16 & export DISPLAY=:1 && fluxbox & x11vnc -display :1 -forever & /usr/share/novnc/utils/launch.sh --listen 6080 --vnc localhost:5900 & wait $!"
