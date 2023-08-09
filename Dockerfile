#To build this file:
#sudo docker build . -t sydneyinformaticshub/bposd

#To run this, mounting your current host directory in the container directory,
# at /project, and excute an example run:
#sudo docker run -it -v `pwd`:/project sydneyinformaticshub/bposd /bin/bash -c "python test.py"

#To push to docker hub:
#sudo docker push sydneyinformaticshub/bposd

#To build a singularity container
#export SINGULARITY_CACHEDIR=`pwd`
#export SINGULARITY_TMPDIR=`pwd`
#singularity build bposd.img docker://sydneyinformaticshub/bposd

#To run the singularity image (noting singularity mounts the current folder by default)
#singularity run --bind /project:/project bposd.img /bin/bash -c "cd "python test.py"

# Pull base image.
FROM ubuntu:16.04
MAINTAINER Nathaniel Butterworth USYD SIH

RUN mkdir /project /scratch && touch /usr/bin/nvidia-smi

# Set up ubuntu dependencies
RUN apt-get update -y && \
  apt-get install -y wget git build-essential curl libgl1 libglib2.0-0 libsm6 libxrender1 libxext6 && \
  rm -rf /var/lib/apt/lists/*

# Make the dir everything will go in
WORKDIR /build

# Intall anaconda
ENV PATH="/build/miniconda3/bin:${PATH}"
ARG PATH="/build/miniconda3/bin:${PATH}"
RUN curl -o miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-py38_4.12.0-Linux-x86_64.sh &&\
	mkdir /build/.conda && \
	bash miniconda.sh -b -p /build/miniconda3 &&\
	rm -rf miniconda.sh

RUN pip install -U bposd

RUN conda clean -a -y
RUN pip cache purge

CMD /bin/bash
