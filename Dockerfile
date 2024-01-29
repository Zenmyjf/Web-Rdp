# Use the official Ubuntu base image
FROM ubuntu:20.04

# Install necessary dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ubuntu-mate-core \
    ubuntu-mate-desktop \
    novnc \
    websockify \
    x11vnc \
    firefox

# Expose ports for noVNC and SSH
EXPOSE 8080
EXPOSE 5901

# Set up the startup script
COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

# Entry point
CMD ["/startup.sh"]
