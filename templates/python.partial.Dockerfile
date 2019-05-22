ARG PYTHON_VER={{ python_version }}

ENV LANG C.UTF-8

#PYTHON SETUP VIA DEAD SNEKS
RUN    apt-add-repository ppa:deadsnakes/ppa && \
       apt-get update -y && \
       apt-get install -y --no-install-recommends \
       python${PYTHON_VER} \
       python${PYTHON_VER}-dev

#Hacky form of try except
RUN    apt-get install -y --no-install-recommends python${PYTHON_VER}-distutils || apt-get install -y --no-install-recommends python3-distutils


RUN    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
       python${PYTHON_VER} get-pip.py && \
       rm get-pip.py  &&  \
       ln -s $(which python${PYTHON_VER}) /usr/local/bin/python &&\
       pip --no-cache-dir install --upgrade \
       pip \
       setuptools