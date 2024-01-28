# Update and install dependencies
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# Add Docker's official GPG key
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# Add the Docker repository
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Update and install Docker
RUN apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io

# Install xorg and gnome
RUN apt update && apt install -y x11vnc xorg gnome-core

# Install noVNC
RUN mkdir -p /usr/share/novnc && \
    cd /usr/share/novnc && \
    wget -O /tmp/noVNC-latest.tar.gz https://github.com/novnc/noVNC/archive/refs/heads/master.tar.gz && \
    tar -xvf /tmp/noVNC-latest.tar.gz && \
    rm /tmp/noVNC-latest.tar.gz

# Copy config files
COPY xstartup /root/.xstartup
COPY novnc.html /usr/share/novnc/index.html

# Start xorg and vncserver
CMD xinit -- /usr/bin/vncserver -geometry 1366x768 :1; \
    /usr/share/novnc/utils/launch.sh --vnc localhost:5901 --listen 6080
