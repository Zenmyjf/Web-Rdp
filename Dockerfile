FROM debian:bookworm

RUN apt update; \
    apt install -y \
        chromium \
        software-properties-common \
        libxext-dev \
        libxrender-dev \
        libxtst-dev

RUN useradd -ms /bin/bash chromium
USER chromium

ENTRYPOINT ["tail", "-f", "/dev/null"]
