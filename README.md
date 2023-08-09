# BP+OSD: A decoder for quantum LDPC codes container

Docker/Singularity image to run [BPOSD](https://pypi.org/project/bposd/) on Centos 6.9 kernel (Ubuntu 16.04)


If you have used this work for a publication, you must acknowledge SIH, e.g: "The authors acknowledge the technical assistance provided by the Sydney Informatics Hub, a Core Research Facility of the University of Sydney."


# Quickstart for Artemis

Put this repo on Artemis e.g.

```
cd /project/<YOUR_PROJECT>
git clone https://github.com/Sydney-Informatics-Hub/bposd-contained.git
```
Then `cd cellranger-contained` and modify the `run_artemis.pbs` script and launch with `qsub run_artemis.pbs`.

Otherwise here are the full instructions for getting there....


# How to recreate

## Build with docker
Check out this repo then build the Docker file.
```
sudo docker build . -t sydneyinformaticshub/bposd
```

## Run with docker.
To run this, mounting your current host directory in the container directory, at /project, and execute a run on the test images (that live in the container) run:
```
sudo docker run -it -v `pwd`:/project sydneyinformaticshub/bposd /bin/bash -c "python test.py"
```

## Push to docker hub
```
sudo docker push sydneyinformaticshub/bposd
```

See the repo at [https://hub.docker.com/r/sydneyinformaticshub/bposd](https://hub.docker.com/r/sydneyinformaticshub/bposd)


## Build with singularity
```
export SINGULARITY_CACHEDIR=`pwd`
export SINGULARITY_TMPDIR=`pwd`

singularity build bposd.img docker://sydneyinformaticshub/bposd
```

## Run with singularity
To run the singularity image (noting singularity mounts the current folder by default)
```
singularity run --bind /project:/project bposd.img /bin/bash -c "cd "$PBS_O_WORKDIR" && python test.py"
```
