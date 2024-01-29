# Use the desired base image, e.g., Ubuntu Jammy
FROM ubuntu:jammy-20230425

# Install necessary packages
RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y ubuntu-mate-desktop locales sudo xrdp tigervnc-standalone-server novnc websockify

# Add a user and set up desktop environment
ARG USER=testuser
ARG PASS=1234
RUN useradd -m $USER -p $(openssl passwd $PASS) && \
    usermod -aG sudo $USER && \
    chsh -s /bin/bash $USER

RUN echo "#!/bin/sh\n\
export XDG_SESSION_DESKTOP=mate\n\
export XDG_SESSION_TYPE=x11\n\
export XDG_CURRENT_DESKTOP=MATE\n\
export XDG_CONFIG_DIRS=/etc/xdg/xdg-mate:/etc/xdg\n\
exec dbus-run-session -- mate-session" > /xstartup && chmod +x /xstartup

# Set up VNC and noVNC
RUN mkdir /home/$USER/.vnc && \
    echo $PASS | vncpasswd -f > /home/$USER/.vnc/passwd && \
    chmod 0600 /home/$USER/.vnc/passwd && \
    chown -R $USER:$USER /home/$USER/.vnc

# Configure xrdp and VNC startup
RUN cp -f /xstartup /etc/xrdp/startwm.sh && \
    cp -f /xstartup /home/$USER/.vnc/xstartup

RUN echo "#!/bin/sh\n\
sudo -u $USER -g $USER -- vncserver -rfbport 5902 -geometry 1920x1080 -depth 24 -verbose -localhost no -autokill no" > /startvnc && chmod +x /startvnc

# Expose ports
EXPOSE 3389
EXPOSE 5902
EXPOSE 6080 8080

# Start services
CMD service dbus start && \
    /usr/lib/systemd/systemd-logind & \
    service xrdp start && \
    /startvnc && \
    websockify -D --web=/usr/share/novnc/ 6080 localhost:5902 && \
    bash
