# vilya

Docker images for data science / deep learning projects


## Features

- `Ubuntu 16.04` and `Ubuntu 18.04`
- `NVIDIA drivers` (requires a [nvidia](https://github.com/NVIDIA/nvidia-docker) runtime to be used)
- `tensorflow 1.13.1` and `tensorflow 2.0.0a`
- `JupyterLab`
- `python 3.6` and `python 3.7`

All images are named with the following convention :

> *base_image*__-__*ubuntu_version*__-__*python_version*__-__*tensorflow_version*__-__*lab_present*

Where:

- `base_image` denotes ubuntu with or without nvidia drivers
- `ubuntu_version` denotes the version of ubuntu 
- `python_version` denotes the version of python
- `tensorflow_version` (tf+version) if present denotes the version of tensorflow.(GPU enabled versions installed on nvidia enabled ubuntus.)
- `lab_present` if jupyter lab is built into the image 


## Usage

Pulling current images from dockerhub:

`docker pull repaydockerhub/image_name`


Building locally:

```bash
pip install -r requirements.txt
python3 assemble.py
docker build -f dockerfile/<image_name> . -t <image_name>
# if its a standard ubuntu image
docker run <image_name>
# else ubuntu_nvidia
docker run --runtime=nvidia <image_name> 
```



## Developing within this project.

> *NOTE* :  At this time there is no versioning strategy in place and the containers pushed 
to dockerhub are not guaranteed to align with what is in this repository. At some point that 
will change (maybe), but in the mean time if your reliance on these images is mission critical 
I suggest you create a fork of this project and manage container versioning on your own. (Or submit a 
pull request here =D ) 
 
### Contents
 
```bash
.
├── requirements.txt # Requirements for assembling docker files
├── assemble.py # Main driver script that puts pieces together
├── dockerfiles/ #Fully described docker files
├── files/  #Files that need to be copied into images
├── options.yaml # Options for assemble.py
├── README.md #This file
├── templates # Jinja templates that provide blocks to be added
│   ├── cleanup.partial.Dockerfile
│   ├── jupyter_lab.partial.Dockerfile
│   ├── no_jupyter_lab.partial.Dockerfile
│   ├── python.partial.Dockerfile
│   ├── tensorflow.partial.Dockerfile
│   ├── ubuntu_all.partial.Dockerfile
│   ├── ubuntu_nvidia.partial.Dockerfile
│   ├── ubuntu.partial.Dockerfile
│   └── ubuntu_version.partial.Dockerfile
└── tests/ #Tests will eventually go here... one day

```

### Testing 

It's manual ATM - submit a PR to fix this or wait for a future date.