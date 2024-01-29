# Use the official Ubuntu base image
FROM ubuntu:22.04

# Separate the commands to identify the problematic package
RUN apt-get update

# Install Ubuntu Mate desktop and other dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y ubuntu-mate-desktop

# Install additional dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tightvncserver xfonts-base x11-xserver-utils novnc websockify

# Clean up after installation
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Expose ports for noVNC and SSH
EXPOSE 8080
EXPOSE 5901

# Set up the startup script
COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

# Entry point
CMD ["/startup.sh"]
