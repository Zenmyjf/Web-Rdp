# Use the Ubuntu 20.04 base image
FROM ubuntu:20.04

# Set the environment variable to avoid interactive questions when installing packages
ENV DEBIAN_FRONTEND=noninteractive

# Set the timezone to your preferred value (replace "America/New_York" with your desired timezone)
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    
# Install required packages (GNOME, VNC, noVNC, etc.)
RUN apt-get update \
    && apt-get install -y \
        gnome-shell \
        ubuntu-gnome-desktop \
        tigervnc-standalone-server \
        novnc \
        websockify \
        xfce4-terminal \
        firefox \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set up VNC password
RUN mkdir -p ~/.vnc \
    && echo "password" | vncpasswd -f > ~/.vnc/passwd \
    && chmod 0600 ~/.vnc/passwd

# Start the VNC server and noVNC
CMD vncserver :1 -localhost no -geometry 1366x768 && websockify -D 6080 localhost:5901
