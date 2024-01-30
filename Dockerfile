# Use an official Chrome image
FROM selenium/standalone-chrome:latest

# Expose noVNC port
EXPOSE 6080

# Set up noVNC and start script
USER root
WORKDIR /opt
RUN sudo apt-get update && \
    sudo apt-get install -y git && \
    git clone https://github.com/novnc/noVNC.git && \
    git clone https://github.com/novnc/websockify.git && \
    echo '#!/bin/bash\n/opt/websockify/run 6080 localhost:5900 &\n/opt/noVNC/utils/launch.sh --vnc localhost:5900 --listen 8080\ntail -f /dev/null' > start.sh && \
    chmod +x start.sh

# Expose noVNC port
EXPOSE 8080

CMD ["/bin/bash", "/opt/start.sh"]
