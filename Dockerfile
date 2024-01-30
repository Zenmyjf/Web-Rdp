# Use the base Ubuntu 20.04 image
FROM ubuntu:20.04

# Set non-interactive mode
ENV DEBIAN_FRONTEND=noninteractive

# Update packages
RUN apt-get update

# Install XFCE, xrdp, tigervnc, Firefox, noVNC, and websockify
RUN apt-get install -y --no-install-recommends xfce4 xfce4-goodies xrdp tigervnc-standalone-server firefox novnc websockify

# Expose the RDP and noVNC ports
EXPOSE 3389
EXPOSE 6080

# Set up entry point
ENTRYPOINT ["bash", "-c", "service xrdp start && websockify -D --web=/usr/share/novnc/ --token-plugin=TokenFile --token-source=/dev/urandom 6080 localhost:3389"]

# CMD to keep the container running
CMD ["bash"]
