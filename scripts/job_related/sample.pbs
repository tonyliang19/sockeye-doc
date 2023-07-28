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