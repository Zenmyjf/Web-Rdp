# Use the official Ubuntu 20.04 base image
FROM ubuntu:20.04

# Set non-interactive environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get -y install xfce4 xfce4-goodies xrdp tigervnc-standalone-server

# Install noVNC
RUN mkdir /usr/share/novnc && \
    cd /usr/share/novnc && \
    wget https://github.com/novnc/noVNC/archive/v1.2.0.tar.gz && \
    tar -xf v1.2.0.tar.gz && \
    mv noVNC-1.2.0/* . && \
    rm -rf noVNC-1.2.0 v1.2.0.tar.gz

# Generate a self-signed certificate
RUN openssl req -x509 -nodes -days 365 -subj "/C=US/ST=California/L=San Francisco/O=Render/CN=localhost" -newkey rsa:2048 -keyout /etc/ssl/private/novnc.key -out /etc/ssl/certs/novnc.crt

# Install Apache and configure it to serve noVNC
RUN apt-get -y install apache2 && \
    a2enmod ssl && \
    a2enmod proxy_http && \
    a2enmod proxy_wstunnel && \
    echo 'ServerName localhost' >> /etc/apache2/apache2.conf && \
    echo '<VirtualHost *:443>' >> /etc/apache2/sites-available/noVNC.conf && \
    echo '  SSLEngine on' >> /etc/apache2/sites-available/noVNC.conf && \
    echo '  SSLCertificateFile /etc/ssl/certs/novnc.crt' >> /etc/apache2/sites-available/noVNC.conf && \
    echo '  SSLCertificateKeyFile /etc/ssl/private/novnc.key' >> /etc/apache2/sites-available/noVNC.conf && \
    echo '  ProxyPass / /usr/share/novnc/' >> /etc/apache2/sites-available/noVNC.conf && \
    echo '  ProxyPassReverse / /usr/share/novnc/' >> /etc/apache2/sites-available/noVNC.conf && \
    echo '  ProxyPass /socket.io /usr/share/novnc/lib/socket.io/' >> /etc/apache2/sites-available/noVNC.conf && \
    echo '  ProxyPassReverse /socket.io /usr/share/novnc/lib/socket.io/' >> /etc/apache2/sites-available/noVNC.conf && \
    echo '  <Location /usr/share/novnc/>' >> /etc/apache2/sites-available/noVNC.conf && \
    echo '    Require all granted' >> /etc/apache2/sites-available/noVNC.conf && \
    echo '  </Location>' >> /etc/apache2/sites-available/noVNC.conf && \
    a2ensite noVNC.conf && \
    systemctl restart apache2

# Launch XRDP and noVNC in the background
CMD ["xrdp", "--nodaemon", "&", "nohup", "vncserver", "-geometry", "1024x768", "-SecurityTypes", "None", "&"]
