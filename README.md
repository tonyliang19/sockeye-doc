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

After running above code snippet by order, or by the [sh file](scripts/jupyter_singularity.sh). You should expect to see like:
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

Now with our image pulled (following instructions from previous [section](#setup-a-singularity-container) ), then you could now submit a job to PBS either using CPU cores or GPU cores (requires special allocation code). The following is a sample script or look [here](scripts/sample.pbs):

```bash
#!/bin/bash

# Instructions
# -l is the option to specify your allocation of resources ADD-ons later
# -l select=1:ncpus=2 number of chunks or nodes and processor per.
# -l ngpus=2 number of gpus required
# -l walltime=hh:mm:ss maximum wall-clock time during which this job can run


# -N is the name of your job, default is name of PBS job script
# -A REQUIRED the allocation code/account to be charged
# -m a|b|e when to send you emails. a: job aborts, b: job begins, e: job ends.
# -M email to receive notifications
# -o path/<name>.out path and file name to return output
# -e path/<name>.err path and file name to return error


#PBS -l walltime=03:00:00,select=1:ncpus=1:mem=5gb
#PBS -N my_jupyter_notebook
#PBS -A <st-alloc-1>
#PBS -m abe
#PBS -M <you.email@ubc.ca>



################################################################################
 
# Change directory into the job dir
# DO NOT CHANGE THIS VARIABLE
cd $PBS_O_WORKDIR
 
# Load software environment
# These are the most frequent one used
module load gcc
module load singularity
 
# Set RANDFILE location to writeable dir
export RANDFILE=$TMPDIR/.rnd
  
# Generate a unique token (password) for Jupyter Notebooks
export SINGULARITYENV_JUPYTER_TOKEN=$(openssl rand -base64 15)
 
# Find a unique port for Jupyter Notebooks to listen on
readonly PORT=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
 
# Print connection details to file
cat > connection_${PBS_JOBID}.txt <<END
 
1. Create an SSH tunnel to Jupyter Notebooks from your local workstation using the following command:
 
ssh -N -L 8890:${HOSTNAME}:${PORT} ${USER}@sockeye.arc.ubc.ca
 
2. Point your web browser to http://localhost:8890
 
3. Login to Jupyter Notebooks using the following token (password):
 
${SINGULARITYENV_JUPYTER_TOKEN}
 
When done using Jupyter Notebooks, terminate the job by:
 
1. Quit or Logout of Jupyter Notebooks
2. Issue the following command on the login node (if you did Logout instead of Quit):
 
qdel ${PBS_JOBID}
 
END
 
# Execute jupyter within the jupyter/datascience-notebook container
# REPLACE <st-alloc-1> <cwl> <my_jupyter> to your project and scratch paths

# exec Run a command within a container
# use \ to denote "ENTER"
"""
Usage:
    singularity exec [exec options ...] <container> <command>

Description:
    singularity exec supports following formats:
    *.sif Singularity Image Format (SIF) The image we have pulled is an example of this

    ... And more, for extra help try singularity exec --help

Options:
    --home string, a home directory specification, the directory to be mounted in your container.

Example:

    singularity exec --home $SCRATCH_PATH \
    container=$PROJECT_PATH/<$IMAGE_PATH>/image.sif \
    command=jupyter notebook 
"""




singularity exec \
  --home /scratch/<st-alloc-1>/<cwl>/<my_jupyter> \
  /arc/project/<st-alloc-1>/jupyter/jupyter-datascience.sif \
  jupyter notebook --no-browser --port=${PORT} --ip=0.0.0.0 --notebook-dir=$PBS_O_WORKDIR

```

## Setup a conda environment

placeholder
