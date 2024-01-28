FROM ubuntu:latest

# Install GNOME and VNC server
RUN apt-get update && apt-get install -y ubuntu-gnome-desktop tightvncserver

# Set up VNC password
RUN mkdir -p ~/.vnc && echo "password" | vncpasswd -f > ~/.vnc/passwd && chmod 600 ~/.vnc/passwd

# Expose VNC port
EXPOSE 5901

# Start VNC server
CMD ["vncserver", ":1", "-geometry", "1280x800", "-depth", "24"]
