# Use a lightweight base image
FROM alpine:latest

# Install necessary packages
RUN apk add --no-cache \
    chromium \
    xvfb \
    x11vnc \
    ttf-freefont

# Set environment variables
ENV DISPLAY=:1 \
    SCREEN_WIDTH=1366 \
    SCREEN_HEIGHT=768 \
    SCREEN_DEPTH=24 \
    HOME=/tmp

# Set up virtual frame buffer
RUN Xvfb $DISPLAY -screen 0 $SCREEN_WIDTHx$SCREEN_HEIGHTx$SCREEN_DEPTH &

# Start chromium with no GPU support
CMD ["chromium-browser", "--no-sandbox", "--disable-gpu", "--disable-software-rasterizer", "--disable-dev-shm-usage", "--disable-setuid-sandbox", "--user-data-dir=/tmp", "--no-first-run", "--start-maximized", "--disable-popup-blocking", "--disable-infobars", "--disable-extensions", "--disable-sync", "--disable-default-apps", "--disable-translate", "--disable-background-networking", "--safebrowsing-disable-auto-update", "--disable-client-side-phishing-detection", "--no-pings", "--headless", "--disable-gpu", "--remote-debugging-address=0.0.0.0", "--remote-debugging-port=9222"]

# Expose noVNC port
EXPOSE 8080
