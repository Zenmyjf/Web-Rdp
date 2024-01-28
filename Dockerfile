# render.yaml
services:
  - name: ubuntu-gnome-desktop
    environment:
      - key: DEBIAN_FRONTEND
        value: noninteractive
    buildCommand: |
      sudo apt-get update
      sudo apt-get install -y ubuntu-gnome-desktop
      sudo apt-get install -y gdm3
      sudo systemctl set-default graphical.target
      sudo apt-get install -y novnc websockify
    startCommand: |
      sudo systemctl start gdm3
      websockify 5901 localhost:5900 --web /usr/share/novnc/
