# Use the official Ubuntu base image
FROM ubuntu:latest

# Set noninteractive mode
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && \
    apt-get install -y \
    gnome-shell \
    ubuntu-gnome-desktop \
    x11vnc \
    xvfb \
    novnc \
    fluxbox \
    supervisor \
    net-tools \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

# Set up VNC and noVNC
RUN mkdir -p ~/.vnc && \
    x11vnc -storepasswd secret ~/.vnc/passwd && \
    chmod 600 ~/.vnc/passwd

RUN echo "[supervisord]" > /etc/supervisor/conf.d/supervisord.conf && \
    echo "nodaemon=true" >> /etc/supervisor/conf.d/supervisord.conf && \
    echo "" >> /etc/supervisor/conf.d/supervisord.conf && \
    echo "[program:x11vnc]" >> /etc/supervisor/conf.d/supervisord.conf && \
    echo "command=/usr/bin/x11vnc -forever -usepw -display :0 -shared" >> /etc/supervisor/conf.d/supervisord.conf && \
    echo "" >> /etc/supervisor/conf.d/supervisord.conf && \
    echo "[program:web]" >> /etc/supervisor/conf.d/supervisord.conf && \
    echo "command=/usr/bin/websockify --web /usr/share/novnc/ --wrap-mode=ignore --tcp-only --ssl-only --cert=/etc/ssl/certs/ssl-cert-snakeoil.pem --key=/etc/ssl/private/ssl-cert-snakeoil.key 8080 localhost:5900" >> /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8080

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
