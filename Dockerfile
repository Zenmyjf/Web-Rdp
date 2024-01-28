# Use the official Ubuntu as a base image
FROM ubuntu:latest

# Set the keyboard origin environment variable to avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true
ENV KEYBOARD_ORIGIN=us

# Update packages and install necessary components
RUN apt-get update && apt-get install -y \
    sudo \
    xfce4 \
    xfce4-goodies \
    x11vnc \
    novnc \
    firefox

# Set up a user
RUN useradd --system -U -u 1000 -m render
RUN echo "render:render" | chpasswd
RUN usermod --shell /bin/bash render
RUN usermod -aG sudo render

# Expose the VNC port
EXPOSE 5900

# Start the VNC server and the web-based noVNC server
CMD bash -c "echo 'render:render' | chpasswd && /usr/bin/sudo -u render -i /usr/bin/startxfce4 & sleep 2 && x11vnc -display :99 -rfbauth /home/render/.vnc/passwd -forever && /usr/bin/sudo -u render -i /usr/bin/websockify -D --web=/usr/share/novnc/ --cert=/etc/ssl/novnc.pem 6080 localhost:5900"
