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
  apt-get install -y wget git build-essential git curl libgl1 libglib2.0-0 libsm6 libxrender1 libxext6 && \
  rm -rf /var/lib/apt/lists/*

# Make the dir everything will go in
WORKDIR /build

RUN curl -o cellranger-7.1.0.tar.gz "https://cf.10xgenomics.com/releases/cell-exp/cellranger-7.1.0.tar.gz?Expires=1675698474&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9jZi4xMHhnZW5vbWljcy5jb20vcmVsZWFzZXMvY2VsbC1leHAvY2VsbHJhbmdlci03LjEuMC50YXIuZ3oiLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjE2NzU2OTg0NzR9fX1dfQ__&Signature=PLekkTNx7NbYv7ul1aMFjGt7NT1KXJHltEb95beWYhfZFVHOOE9ZKtWuSMZmruHDRVFO57bGDLn8z7d-lZ8~lGHs32uNokNHs2fpsqvpj2IZmzUb4-WXi5W75V3TiQY580cCVxC8bY9-S3JOJfs~7aLS2ZVhIlyMMM2yf1SaeCPxEnPKoOLDcgRC8D7gZUd3Os6n-n0YI1vnOFC4FvaEtSvf~6lmJIqhxonWiIn3Wg9GU-frlGn6aTFwfCPfceT2ukaAna1-S~K0mjBeiHbZ7Y7PvPkRYPNpJ81XTqAl8sz7F0N7zdrS9mDE~kCa3lfGVrCzfV30~K0dA98UgxXzTw__&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA"
#
RUN tar -xvf cellranger-7.1.0.tar.gz

ENV PATH=""/build/cellranger-7.1.0:${PATH}""

CMD cellranger
