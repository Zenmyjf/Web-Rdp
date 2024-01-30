# Use a lightweight Linux distribution as the base image
FROM alpine:latest

# Install necessary packages
RUN apk --no-cache add \
    chromium \
    xvfb \
    fluxbox \
    supervisor \
    ttf-freefont \
    x11vnc \
    novnc

# Set up the display environment
ENV DISPLAY=:1 \
    VNC_PORT=5901 \
    NOVNC_PORT=8080

# Set up supervisor to manage processes
COPY supervisord.conf /etc/supervisord.conf

# Expose ports for VNC and noVNC
EXPOSE $VNC_PORT $NOVNC_PORT

# Start supervisord to manage the processes
CMD ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
