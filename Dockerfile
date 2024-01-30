# Use a lightweight base image
FROM debian:bullseye-slim

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y \
    xvfb \
    fluxbox \
    x11vnc \
    wget \
    bzip2 \
    && rm -rf /var/lib/apt/lists/*

# Download and install the browser (e.g., Firefox)
RUN wget -O /tmp/firefox.tar.bz2 "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64" && \
    tar -xjf /tmp/firefox.tar.bz2 -C /opt/ && \
    ln -s /opt/firefox/firefox /usr/bin/firefox && \
    rm /tmp/firefox.tar.bz2

# Set up the entry point script
ENTRYPOINT ["bash", "-c", "\
    Xvfb :1 -screen 0 1024x768x16 & \
    fluxbox & \
    x11vnc -display :1 -nopw -listen 0.0.0.0 -forever & \
    firefox --display=:1 & \
    tail -f /dev/null \
"]

# Expose the VNC port
EXPOSE 5900
