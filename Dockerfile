# Use a lightweight base image
FROM alpine:latest

# Install necessary packages
RUN apk --update --no-cache add \
    tigervnc-server \
    fluxbox \
    supervisor \
    xvfb \
    xterm \
    firefox

# Expose port for noVNC
EXPOSE 8080

# Set up noVNC
RUN wget -qO- https://github.com/novnc/noVNC/archive/v1.2.0.tar.gz | tar xz --strip 1 -C /usr/share/novnc

# Configure noVNC
RUN wget -qO- https://raw.githubusercontent.com/novnc/noVNC/v1.2.0/vnc.html > /usr/share/novnc/index.html

# Create a non-root user
RUN adduser -D user

# Set up supervisor to manage processes
RUN echo -e "[supervisord]\nnodaemon=true\n[program:xvfb]\ncommand=/usr/bin/Xvfb :1 -screen 0 1024x768x16\n[program:x11vnc]\ncommand=/usr/bin/x11vnc -display :1 -nopw -listen localhost -xkb\n[program:novnc]\ncommand=/usr/share/novnc/utils/launch.sh --vnc localhost:5900" > /etc/supervisord.conf

# Start supervisor
CMD ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
