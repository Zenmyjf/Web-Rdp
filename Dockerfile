# Use an official Firefox image
FROM selenium/standalone-firefox:latest

# Expose noVNC port
EXPOSE 6080

# Set up noVNC and start script
USER root
WORKDIR /opt

# Install necessary packages
RUN sudo apt-get update && \
    sudo apt-get install -y git python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Clone noVNC and websockify
RUN git clone --depth 1 https://github.com/novnc/noVNC.git && \
    git clone --depth 1 https://github.com/novnc/websockify.git

# Install numpy using pip
RUN python3 -m pip install numpy

# Create start script
RUN echo '#!/bin/bash\n/opt/websockify/run 6080 localhost:5900 &\n/opt/noVNC/utils/launch.sh --vnc localhost:5900 --listen 8080\nsleep infinity' > start.sh && \
    chmod +x start.sh

# Expose noVNC port
EXPOSE 8080

CMD ["/bin/bash", "/opt/start.sh"]
