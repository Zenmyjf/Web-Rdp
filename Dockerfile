# Use the official Ubuntu base image
FROM ubuntu:20.04

# Install necessary dependencies for Ubuntu Mate Desktop and noVNC
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ubuntu-mate-desktop \
    tightvncserver \
    xfonts-base \
    x11-xserver-utils \
    novnc \
    websockify \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set up a VNC password
RUN mkdir -p ~/.vnc && \
    echo "password" | vncpasswd -f > ~/.vnc/passwd && \
    chmod 600 ~/.vnc/passwd

# Expose VNC and noVNC ports
EXPOSE 5901
EXPOSE 6080

# Start VNC server and noVNC on container startup
CMD ["bash", "-c", "vncserver :1 -geometry 1280x800 -depth 24 && websockify -D --web=/usr/share/novnc/ --token-fork -- 6080"]
