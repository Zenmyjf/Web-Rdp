# Create a new Dockerfile
FROM ubuntu:20.04

# Update the package manager
RUN apt update && apt upgrade -y

# Install Gnome and noVNC
RUN apt install -y gnome-session gnome-shell gnome-terminal noVNC

# Configure noVNC
RUN sed -i 's/ENABLED=0/ENABLED=1/' /etc/default/novnc
RUN sed -i 's/websockify -D --web /websockify -D --web=81:/' /etc/novnc/default.conf

# Start noVNC
RUN service novnc start

# Add the user
RUN useradd -m user

# Set the user's password
RUN echo 'user:user' | chpasswd

# Copy the SSH keys
COPY authorized_keys /home/user/.ssh/authorized_keys

# Set the default shell
RUN usermod -s /bin/bash user

# Allow the user to run Docker commands without sudo
RUN usermod -aG docker user

# Expose ports 22 (SSH), 6080 (VNC) and 81 (noVNC)
EXPOSE 22 6080 81

# Start the SSH daemon
CMD ["/usr/sbin/sshd", "-D"]
