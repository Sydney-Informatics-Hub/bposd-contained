#To build this file:
#sudo docker build . -t nbutter/cellranger:ubuntu1604

#To run this, mounting your current host directory in the container directory,
# at /project, and excute an example run:
#sudo docker run -it -v `pwd`:/project nbutter/cellranger:ubuntu1604 /bin/bash -c "cellranger sitecheck > /project/sitecheck.txt"

#To push to docker hub:
#sudo docker push nbutter/cellranger:ubuntu1604

#To build a singularity container
#export SINGLUARITY_CACHEDIR=`pwd`
#export SINGLUARITY_TMPDIR=`pwd`
#singularity build cellranger.img docker://nbutter/cellranger:ubuntu1604

#To run the singularity image (noting singularity mounts the current folder by default)
#singularity run --bind /project:/project cellranger.img /bin/bash -c "cd "$PBS_O_WORKDIR" && cellranger sitecheck > sitecheck.txt"

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
