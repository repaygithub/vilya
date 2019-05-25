FROM ubuntu:${UBUNTU_VERSION} as base

SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    apt-get install -y --no-install-recommends\
    build-essential \
    curl \
    libfreetype6-dev \
    libhdf5-serial-dev \
    libzmq3-dev \
    pkg-config \
    software-properties-common \
    unzip \
    sudo \
     wget \
    bzip2 \
    ca-certificates \
    locales \
    fonts-liberation \
    git && \
    rm -rf /var/lib/apt/lists/*

