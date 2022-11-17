# UBC ARC Sockeye Documentation Cheat Sheet

By: Tony Liang

This is a documentaion for setup singularity container + conda environment on sockeye ARC, for full reference see [here](https://confluence.it.ubc.ca/display/UARC/Quickstart+Guide#QuickstartGuide-ConnectingtoSockeye)


Table of Contents:
 1. [Sockeye and its environment](#sockeye-and-its-environment)
 2. [Setup a singularity container](#setup-a-singularity-container)
 3. [Running jobs to spawn your container](#running-jobs-to-spawn-your-container)
 4. [Setup a conda environment](#setup-a-conda-environment)

## Sockeye and its environment

Sockeye is a computing platform that uses PBS as its job manager instead of SLURM, hence for the documentation of how to submit PBS jobs and specifying options, please see [here](PBSUserGuide2022.1.pdf)

Things you should know:

- Once you ssh into the platform, your pwd likely to be: `/home/$USER`, whereas `$USER` is default environment variable and you should also have `ALLOC=the allocation code`, if not defined you could add it to `~/.bash_profile`.
- You will be working in two main directories: `/arc/project/$ALLOC/$USER` or `/scratch/$ALLOC/$USER`. The first one is to store final results/outputs of your works, the latter one for all other purposes, and recommended to use for experiments. **NOTE**: Defining the two paths into two env would ease your life much.

**Some useful modules to use**:
- module load miniconda3 , this allows you to use conda on Sockeye (explain later)
- module load git, this allows you to use git (must be loaded first via module load)
- module load cuda cudnn, these are two modules that are used when requires GPU access

```bash
# Assuming this is the bash_profile
if ... then
    ...
fi
# This is the allocation code (usually defined by PI)
ALLOC=st-<pi_name>
export ALLOC

# This is the path to project
PROJECT_PATH=/arc/project/$ALLOC/$USER
export PROJECT_PATH

# This is the path to scratcg
SCRATCH_PATH=/scratch/$ALLOC/$USER
export SCRATCH_PATH
```         

## Setup a singularity container

Singularity is a type of containerization as Docker, and is the software mainly used on Sockeye. We could use this to spawn some interactive session like Jupyter Lab. It is very similar to Docker, where you pull remote image to your local (this case Sockeye), and then access this image every time we want to mount volumes from the image. Conventionally, store this image in your `$PROJECT_PATH` rather than `$SCRATCH_PATH` For this you need to run this following script or see [here](jupyter_singularity.sh):

```bash
#!/bin/bash

# Load required modules on sockeye
module load gcc 
module load singularity

# Chance to the directory you want to store the image
# For easiness of storing files, I purposedly stored this to an extra dir prior to create it

# This is the path to store the image
# You could change the name of your image
# We called it "jupyter-datascience.sif" here, .sif extension is must
IMAGE_PATH=$PROJECT_PATH/images
if [-d "IMAGE_PATH"];
then
    echo "This path does not exist yet, creating it now"
    mkdir -p $IMAGE_PATH
    cd $IMAGE_PATH
    echo "Path created at ${IMAGE_PATH} and image pulled to here"
    singularity pull --force --name jupyter-datascience.sif docker://jupyter/datascience-notebook
    echo "Image successfully pulled to ${IMAGE_PATH}"
else
    cd $IMAGE_PATH
    echo "Pulling image at ${IMAGE_PATH}"
    singularity pull --force --name jupyter-datascience.sif docker://jupyter/datascience-notebook
    echo "Image successfully pulled to ${IMAGE_PATH}"
```

After running above code snippet by order, or by the [sh file](jupyter_singularity.sh). You should expect to see like:
```markdown
INFO: Converting OCI blobs to SIF format
INFO: Starting build...
Getting image source signatures
copying blob ....
copying blob ....

...
...
...

INFO: Creating SIF file...
```
And it is normal to see some warnings there or xxx skipped already exists. After having the container image stored preferredly in your project directory, then you could start submitting a job to PBS and run an extra ssh session from your local computer mounted by Jupyter container.

## Running jobs to spawn your container

placeholder

## Setup a conda environment

placeholder
