
# Use a base image with a minimal Linux distribution and Xfce desktop environment
FROM dorowu/ubuntu-desktop-lxde-vnc:bionic

# Install a web browser
RUN apt-get update && apt-get install -y firefox

# Expose the default noVNC port
EXPOSE 6080

# Set the startup command to run noVNC and the web browser
CMD ["--wait", "99999", "--scale", "1280x720", "--quality", "9", "--", "firefox"]
