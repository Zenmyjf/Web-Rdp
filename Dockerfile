# Create a new Render service
render service create \
  --service-name my-desktop \
  --image docker.io/ubuntu:22.04 \
  --env VNC_RESOLUTION=1920x1080 \
  --env VNC_PASSWORD=my-password

# Wait for the service to deploy
render service wait \
  --service-name my-desktop

# Get the service URL
service_url=$(render service get \
  --service-name my-desktop \
  --field urls.novnc)

# Connect to the service using NoVNC
open $service_url
