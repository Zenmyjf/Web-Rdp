# Use a lightweight base image
FROM debian:bullseye-slim

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y \
    firefox \
    xvfb \
    x11vnc \
    fluxbox \
    && rm -rf /var/lib/apt/lists/*

# Set up a minimalistic Fluxbox configuration
RUN mkdir -p /root/.fluxbox
RUN echo "session.screen0.rootCommand: fbsetbg -solid \"#2E2E2E\"" >> /root/.fluxbox/init
RUN echo "session.screen0.toolbar.visible: false" >> /root/.fluxbox/init
RUN echo "session.screen0.workspaceNames: 1" >> /root/.fluxbox/init
RUN echo "session.screen0.workspaces: 1" >> /root/.fluxbox/init
RUN echo "session.screen0.toolbar.slit.placement: ScreenRight" >> /root/.fluxbox/init
RUN echo "session.screen0.toolbar.slit.autoHide: true" >> /root/.fluxbox/init
RUN echo "session.screen0.toolbar.slit.maxOver: false" >> /root/.fluxbox/init
RUN echo "session.screen0.toolbar.slit.maxUnder: false" >> /root/.fluxbox/init
RUN echo "session.screen0.toolbar.slit.onTop: false" >> /root/.fluxbox/init
RUN echo "session.screen0.toolbar.slitLayer: Normal" >> /root/.fluxbox/init
RUN echo "session.screen0.tab.placement: TopRight" >> /root/.fluxbox/init
RUN echo "session.screen0.tab.width: 64" >> /root/.fluxbox/init
RUN echo "session.screen0.iconbar.mode: Workspace" >> /root/.fluxbox/init
RUN echo "session.screen0.menuFile: /etc/X11/fluxbox/fluxbox-menu" >> /root/.fluxbox/init

# Set up the entry point script
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

# Expose the VNC port
EXPOSE 5900

# Specify the command to run on container startup
CMD ["/usr/bin/entrypoint.sh"]
