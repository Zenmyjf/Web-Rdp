# Use an official Ubuntu image
FROM ubuntu:latest

# Set the keyboard layout (replace "us" with your desired layout)
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y keyboard-configuration
RUN echo "keyboard-configuration keyboard-configuration/layout select us" | debconf-set-selections
RUN dpkg-reconfigure -f noninteractive keyboard-configuration

# Install necessary packages
RUN apt-get install -y xfce4 xfce4-goodies tightvncserver novnc websockify chromium-browser anydesk

# Expose ports for VNC, noVNC, AnyDesk
EXPOSE 5901
EXPOSE 6080
EXPOSE 7070 7071 7072 # AnyDesk ports

# Set up VNC and noVNC
RUN mkdir -p ~/.vnc && echo "password" | vncpasswd -f > ~/.vnc/passwd
RUN chmod 600 ~/.vnc/passwd

# Set the USER environment variable
ENV USER=root

# Start the VNC server with XFCE and AnyDesk
CMD vncserver :1 -geometry 1280x800 -depth 24 && websockify --web=/usr/share/novnc/ 6080 localhost:5901 && anydesk -- --plughw:1
