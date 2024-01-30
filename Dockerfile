# Use a lightweight base image
FROM alpine:latest

# Install necessary dependencies
RUN apk add --no-cache \
    chromium \
    xvfb \
    dbus \
    ttf-freefont \
    fluxbox \
    supervisor \
    git \
    python3 \
    py3-numpy \
    py3-pillow \
    py3-lxml \
    py3-psutil \
    py3-websocket-client

# Install noVNC
WORKDIR /opt
RUN git clone https://github.com/novnc/noVNC.git && \
    git clone https://github.com/novnc/websockify.git

# Set up a supervisor to manage processes
COPY supervisord.conf /etc/supervisord.conf

# Expose port for noVNC
EXPOSE 8080

# Start the supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
