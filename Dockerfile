FROM ubuntu:22.04
LABEL maintainer="Your Name <your.name@example.com>"

# Install GNOME desktop environment
RUN apt-get update && \
    apt-get install -y \
    gnome-session \
    gnome-terminal \
    gnome-panel \
    gnome-settings-daemon \
    gnome-backgrounds \
    gnome-screenshot \
    gnome-system-monitor \
    gnome-schedule \
    gnome-weather \
    gnome-clocks \
    gnome-nautilus \
    gnome-disk-utility \
    gnome-font-viewer \
    gnome-calculator \
    gnome-text-editor \
    gnome-maps \
    gnome-contacts \
    gnome-software

# Install NoVNC
RUN apt-get update && \
    apt-get install -y \
    novnc \
    websockify

# Configure NoVNC
RUN sed -i 's/#websockify/websockify/' /etc/novnc/default.conf
RUN sed -i 's/#allow/allow/' /etc/novnc/default.conf

# Expose ports
EXPOSE 6080

# Start NoVNC
CMD /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
