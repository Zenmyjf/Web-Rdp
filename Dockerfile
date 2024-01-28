FROM ubuntu:22.04

# Install xfce4 desktop environment
RUN apt update && apt install -y xfce4 xfce4-goodies xorg

# Install noVNC
RUN apt-get update && apt-get install -y novnc

# Install x11vnc
RUN apt-get update && apt-get install -y x11vnc

# Configure noVNC
RUN sed -i 's/#listening_port = 6080/listening_port = 6901/g' /etc/novnc/default.conf

# Enable and start x11vnc
RUN systemctl enable x11vnc && systemctl start x11vnc

# Start noVNC
RUN systemctl enable novnc && systemctl start novnc

# Run xfce4
RUN startxfce4

# Expose port 80 for noVNC
EXPOSE 80

# Keep container running
CMD sleep infinity
