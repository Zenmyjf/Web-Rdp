# Use an official Ubuntu image
FROM ubuntu:latest

# Set the keyboard layout (replace "us" with your desired layout)
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y keyboard-configuration
RUN echo "keyboard-configuration keyboard-configuration/layout select us" | debconf-set-selections
RUN dpkg-reconfigure -f noninteractive keyboard-configuration

# Install XFCE and VNC dependencies
RUN apt-get install -y xfce4 xfce4-goodies tightvncserver

# Install noVNC and websockify
RUN apt-get install -y novnc websockify

# Install Chromium browser and AnyDesk dependencies
RUN apt-get install -y chromium-browser libnss3-dev libxss1 libasound2 libatk-bridge2.0-0 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6

# Download and install AnyDesk
ADD https://download.anydesk.com/linux/anydesk_6.0.1-1_amd64.deb /tmp/anydesk.deb
RUN dpkg -i /tmp/anydesk.deb && apt-get install -f -y && rm /tmp/anydesk.deb

# Expose ports for VNC, noVNC, AnyDesk
EXPOSE 5901
EXPOSE 6080
EXPOSE 7070

# Set up VNC and noVNC
RUN mkdir -p ~/.vnc && echo "password" | vncpasswd -f > ~/.vnc/passwd
RUN chmod 600 ~/.vnc/passwd

# Set the USER environment variable
ENV USER=root

# Start the VNC server with XFCE and AnyDesk
CMD vncserver :1 -geometry 1280x800 -depth 24 && websockify --web=/usr/share/novnc/ 6080 localhost:5901 && anydesk -- --plughw:1
