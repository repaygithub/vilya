####      ADAPTED FROM     #############################################################################################
# https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/dockerfiles/dockerfiles/gpu-jupyter.Dockerfile #
#
#
#
#
########################################################################################################################

ARG UBUNTU_VERSION=16.04
ARG CUDA=10.0

FROM nvidia/cuda:${CUDA}-base-ubuntu${UBUNTU_VERSION} as base
ARG UBUNTU_VERSION
ARG CUDA
ARG CUDNN=7.4.1.5-1
# TF ONLY SUPPORTS TO 3.6 RIGHT NOW
ARG PYTHON_VER=3.7
# TODO: PIN VERSION for consistency
ARG TF_PACKAGE=tensorflow-gpu
ARG TF_PACKAGE_VERSION=

ENV LANG C.UTF-8


SHELL ["/bin/bash","-c"]

RUN apt-get update &&\
        apt-get install -y --no-install-recommends \
        build-essential \
        cuda-command-line-tools-${CUDA/./-} \
        cuda-cublas-${CUDA/./-} \
        cuda-cufft-${CUDA/./-} \
        cuda-curand-${CUDA/./-} \
        cuda-cusolver-${CUDA/./-} \
        cuda-cusparse-${CUDA/./-} \
        curl \
        libcudnn7=${CUDNN}+cuda${CUDA} \
        libfreetype6-dev \
        libhdf5-serial-dev \
        libzmq3-dev \
        pkg-config \
        software-properties-common \
        unzip \
        python-pip \
        python3-pip

RUN     apt-get update && \
        apt-get install nvinfer-runtime-trt-repo-ubuntu1604-5.0.2-ga-cuda${CUDA} \
        && apt-get update \
        && apt-get install -y --no-install-recommends libnvinfer5=5.0.2-1+cuda${CUDA}

ENV LD_LIBRARY_PATH /usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH


#PYTHON SETUP VIA DEAD SNEKS
RUN    apt-add-repository ppa:deadsnakes/ppa && \
       apt-get update -y && \
       apt-get install -y --no-install-recommends \
       python${PYTHON_VER} \
       python${PYTHON_VER}-dev\
       python${PYTHON_VER}-distutils && \
       curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
       python${PYTHON_VER} get-pip.py && \
       rm get-pip.py  &&  \
       ln -s $(which python${PYTHON_VER}) /usr/local/bin/python &&\
       pip --no-cache-dir install --upgrade \
       pip \
       setuptools


# INSTALL TF-GPU, DEFAULTS TO THE latest VERSION
RUN pip install ${TF_PACKAGE}${TF_PACKAGE_VERSION:+==${TF_PACKAGE_VERSION}}

# CLEANUP
RUN  apt-get clean \
     && rm -rf /var/lib/apt/lists/*

# Add Tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]