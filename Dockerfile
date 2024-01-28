# Use an official Ubuntu image
FROM ubuntu:latest

# Set the keyboard layout and timezone
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y tzdata keyboard-configuration
RUN ln -snf /usr/share/zoneinfo/America/New_York /etc/localtime && echo "America/New_York" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata keyboard-configuration

# Install full GNOME desktop environment and necessary packages for VNC and noVNC
RUN apt-get install -y ubuntu-gnome-desktop tightvncserver novnc websockify

# Expose ports for VNC and noVNC
EXPOSE 5901
EXPOSE 6080

# Set up VNC
RUN mkdir -p ~/.vnc && echo "password" | vncpasswd -f > ~/.vnc/passwd
RUN chmod 600 ~/.vnc/passwd

# Set the USER environment variable
ENV USER=root

# Start the VNC server with GNOME and noVNC
CMD ["bash", "-c", "vncserver :1 -geometry 1280x800 -depth 24 -extension RANDR -fp /usr/share/fonts/X11/misc && websockify --web=/usr/share/novnc/ 6080 localhost:5901"]
