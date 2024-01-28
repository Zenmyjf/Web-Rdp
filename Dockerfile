# Set up the base image and install the GNOME desktop environment
FROM ubuntu:20.04

# Update the package list and install necessary packages
RUN apt update -y && apt install -y tasksel

# Install the GNOME desktop environment
RUN tasksel install ubuntu-desktop --no-install-recommends

# Set timezone to Asia
RUN ln -snf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime

# Install noVNC and the associated dependencies
RUN apt install -y novnc x11vnc supervisor

# Configure noVNC
RUN echo -e "novnc --listen 6080 --vnc localhost:5901 --password ABC123" > /etc/novnc.conf

# Run noVNC at startup
RUN sed -i '/exit 0/d' /etc/rc.local
RUN echo "/usr/bin/supervisord -n -c /etc/novnc.conf" >> /etc/rc.local

# Start noVNC
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/novnc.conf"]
