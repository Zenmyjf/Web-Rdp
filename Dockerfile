
# Use a lightweight Linux distribution as the base image
FROM alpine:latest

# Install necessary packages
RUN apk update && apk add --no-cache \
    x11vnc \
    xvfb \
    fluxbox \
    wget \
    openbox \
    ttf-freefont \
    supervisor

# Install the internet browser (e.g. Firefox)
RUN apk add --no-cache firefox-esr

# Install noVNC
RUN wget -P /tmp https://github.com/novnc/noVNC/archive/v1.2.0.tar.gz && \
    tar -xzf /tmp/v1.2.0.tar.gz -C /opt && \
    mv /opt/noVNC-1.2.0 /opt/novnc

# Expose the VNC port
EXPOSE 5900

# Set the entry point and start command
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
