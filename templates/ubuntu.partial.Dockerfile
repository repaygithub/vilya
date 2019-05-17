FROM ubuntu:${UBUNTU_VERSION} as base

RUN apt-get update && \
    apt-get install -y --no-install-recommends\
    build-essential \
    curl \
    libfreetype6-dev \
    libhdf5-serial-dev \
    libzmq3-dev \
    pkg-config \
    software-properties-common \
    unzip
