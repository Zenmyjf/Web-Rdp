FROM render/no-vnc:latest

# Install Chrome browser
RUN apt-get update && apt-get install -y chromium-browser

# Copy noVNC dependencies
COPY ./noVNC /usr/share/novnc

# Configure noVNC
RUN ln -s /usr/share/novnc /var/www/html/vnc
RUN ln -s /var/run/novnc /tmp
RUN chown www-data:www-data /tmp/websockify0.log

# Expose port 80 for HTTP traffic and port 6080 for WebSocket traffic
RUN sed -i -- 's/# listen = 8080/# listen = 6080/' /usr/share/novnc/utils/launch.sh
RUN sed -i -- 's/# port = 8080/# port = 80/' /usr/share/novnc/utils/launch.sh

# Run noVNC in the background
RUN sh -c 'cd /usr/share/novnc && sudo ./utils/launch.sh --vnc localhost:5900 > /var/log/novnc.log 2>&1 &'

# Start the Chromium browser
CMD ["chromium-browser", "--remote-debugging-port=9222", "--no-sandbox"]
