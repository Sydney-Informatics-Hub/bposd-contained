# Cell Ranger Container

Docker/Singularity image to run [Cell Ranger](https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/using/tutorial_in) on Centos 6.9 kernel (Ubuntu 16.04)


If you have used this work for a publication, you must acknowledge SIH, e.g: "The authors acknowledge the technical assistance provided by the Sydney Informatics Hub, a Core Research Facility of the University of Sydney."


# Quickstart for Artemis

Put this repo on Artemis e.g.

```
cd /project/<YOUR_PROJECT>
git clone https://github.com/Sydney-Informatics-Hub/cellranger-contained.git
```
Then `cd cellranger-contained` and modify the `run_artemis.pbs` script and launch with `qsub run_artemis.pbs`.

Otherwise here are the full instructions for getting there....


# How to recreate

## Build with docker
Check out this repo then build the Docker file.
```
sudo docker build . -t nbutter/cellranger:ubuntu1604
```

## Run with docker.
To run this, mounting your current host directory in the container directory, at /project, and execute a run on the test images (that live in the container) run:
```
sudo docker run -it -v `pwd`:/project nbutter/cellranger:ubuntu1604 /bin/bash -c "cellranger sitecheck > /project/sitecheck.txt"
```

## Push to docker hub
```
sudo docker push nbutter/cellranger:ubuntu1604
```

See the repo at [https://hub.docker.com/r/nbutter/cellranger](https://hub.docker.com/r/nbutter/cellranger)


## Build with singularity
```
export SINGULARITY_CACHEDIR=`pwd`
export SINGULARITY_TMPDIR=`pwd`

singularity build cellranger.img docker://nbutter/cellranger:ubuntu1604
```

## Run with singularity
To run the singularity image (noting singularity mounts the current folder by default)
```
singularity run --bind /project:/project cellranger.img /bin/bash -c "cd "$PBS_O_WORKDIR" && export TENX_IGNORE_DEPRECATED_OS=1; cellranger sitecheck > sitecheck.txt"
```
