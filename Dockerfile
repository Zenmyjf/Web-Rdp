# Create a new Dockerfile for Ubuntu GNOME with noVNC

# Use the official Ubuntu 20.04 GNOME image as the base image
FROM ubuntu:20.04

# Update the package repository cache
RUN apt update

# Install the GNOME desktop environment
RUN apt install -y gnome-session gnome-shell

# Install noVNC
RUN apt install -y novnc

# Configure noVNC
RUN ln -s /usr/share/novnc /var/www/html

# Create a user for the VNC session
RUN useradd -ms /bin/bash vncuser && echo "vncuser:password" | chpasswd

# Expose port 8080 for noVNC
EXPOSE 8080

# Start the VNC server
CMD ["/usr/bin/x11vnc", "-display", ":0", "-auth", "guess", "-rfbport", "5900", "-forever", "-shared"]
