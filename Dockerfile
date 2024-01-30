# Use a minimal Linux distribution as the base image
FROM debian:buster-slim

# Install necessary tools and libraries
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        xvfb \
        fluxbox \
        x11vnc \
        novnc \
        websockify \
        wget \
        bzip2 \
        ca-certificates \
        procps \
        midori \
    && rm -rf /var/lib/apt/lists/*

# Download and unpack noVNC
WORKDIR /usr/share
RUN wget -O noVNC.tar.gz https://github.com/novnc/noVNC/archive/v1.2.0.tar.gz \
    && tar xzf noVNC.tar.gz \
    && rm noVNC.tar.gz \
    && mv noVNC-* novnc

# Copy the start script into the image
COPY start.sh /usr/share/novnc/start.sh
RUN chmod +x /usr/share/novnc/start.sh

# Expose the default noVNC port
EXPOSE 6080

# Set the startup command to initiate noVNC and the web browser
CMD ["/usr/share/novnc/start.sh"]
