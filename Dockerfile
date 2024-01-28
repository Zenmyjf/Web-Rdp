FROM ubuntu:20.04

# Install dependencies and tools
RUN apt-get update && \
    apt-get install -y \
    git \
    automake \
    libtool \
    libssl-dev \
    libjpeg-dev \
    libpam0g-dev \
    libx11-dev \
    libpulse-dev \
    python3 \
    python3-pip \
    xserver-xorg \
    x11-xserver-utils \
    xfce4 \
    xfce4-goodies \
    lightdm \
    openssh-server \
    firefox

# Install noVNC server
RUN git clone https://github.com/novnc/noVNC.git /noVNC
WORKDIR /noVNC
RUN ant jar

# Configure and install
RUN cp /noVNC/config/client/websockify/websockify.conf.example \
    /noVNC/config/client/websockify/websockify.conf \
    && cp /noVNC/config/vnc/vnc_auto.conf.example \
    /noVNC/config/vnc/vnc_auto.conf

RUN sed -i 's/localhost/0.0.0.0/' /noVNC/config/client/websockify/websockify.conf
RUN sed -i 's/-web=8443 -port=5900/-web=9090 -port=6080/' /noVNC/config/client/websockify/websockify.conf
RUN sed -i 's/-path=\\\\/websockify/-path=\\\\/' /noVNC/config/client/websockify/websockify.conf
RUN sed -i 's/#origin=http://localhost:8080/origin=http://localhost:9090/' /noVNC/config/vnc/vnc_auto.conf
RUN sed -i 's/-listen=\\[::\]:443/-listen=\\[::\]:6080/' /noVNC/config/vnc/vnc_auto.conf

# Automatically start noVNC server on boot
RUN systemctl enable websockify
RUN systemctl enable vncserver-start
RUN systemctl enable ssh

# Start noVNC server
RUN service websockify start
RUN service vncserver-start start

# Copy noVNC files to container root dir
RUN cp -r /noVNC/* /

# Use Apache as proxy to server noVNC on port 80
RUN apt-get update && \
    apt-get install -y \
    apache2

RUN a2enmod proxy proxy_wstunnel proxy_http

RUN echo "ProxyPass / http://127.0.0.1:9090/
ProxyPassReverse / http://127.0.0.1:9090/" >> /etc/apache2/sites-available/000-default.conf

# Start Apache
RUN service apache2 start

# Custom SSH config
RUN sed -i 's/#UsePAM yes/UsePAM no/' /etc/ssh/sshd_config
RUN service ssh restart

# Install VNC Server
RUN apt-get install -y xfce4-session xorg xfce4-terminal tigervnc-standalone-server

RUN mkdir /root/.vnc

RUN echo 'VNCSERVERS="1:x0"' >> /etc/default/vncserver
RUN echo '[XGeom]
        800x600' >> /root/.vnc/xstartup

RUN systemctl enable vncserver-x0-service

# Start VNC Server
RUN vncserver

# Cleanup
RUN rm -rf /noVNC
