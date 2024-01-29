# Use the official Ubuntu base image
FROM ubuntu:latest

# Set non-interactive mode during installation
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York

# Set the timezone
RUN ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

# Install necessary packages
RUN apt-get update && apt-get install -y \
    ubuntu-desktop \
    x11vnc \
    xvfb \
    novnc \
    dbus-x11 \
    supervisor \
    gnome-terminal \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set up noVNC
ENV DISPLAY=:1 \
    VNC_PORT=5901 \
    NOVNC_PORT=6901

# Set the noVNC password
ENV VNC_PASSWORD=your_password

# Expose ports
EXPOSE $VNC_PORT $NOVNC_PORT

# Add supervisor configuration
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Start supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
