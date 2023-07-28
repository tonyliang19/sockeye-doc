#!/bin/bash
 
#PBS -l walltime=03:00:00,select=1:ncpus=1:mem=64gb
#PBS -N my_jupyter_notebook
#PBS -A st-singha53-1
 
################################################################################
# Change directory into the job dir
cd $PBS_O_WORKDIR

# Load envs
source ./01-setup_env_vars.sh

# Load software environment
module load gcc
module load apptainer

# Set RANDFILE location to writeable dir
export RANDFILE=$TMPDIR/.rnd
 
# Generate a unique token (password) for Jupyter Notebooks
export APPTAINERENV_JUPYTER_TOKEN=$(openssl rand -base64 15)

# Find a unique port for Jupyter Notebooks to listen on
readonly PORT=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')

# Print connection details to file
cat > connection_${PBS_JOBID}.txt <<END

1. Create an SSH tunnel to Jupyter Notebooks from your local workstation using the following command:

ssh -N -L 8888:${HOSTNAME}:${PORT} ${USER}@sockeye.arc.ubc.ca

2. Point your web browser to http://localhost:8888

3. Login to Jupyter Notebooks using the following token (password):

${APPTAINERENV_JUPYTER_TOKEN}

When done using Jupyter Notebooks, terminate the job by:

1. Quit or Logout of Jupyter Notebooks
2. Issue the following command on the login node (if you did Logout instead of Quit):

qdel ${PBS_JOBID}

END

# Execute jupyter within the jupyter/datascience-notebook container
apptainer exec \
  --home ${SRC} \
  --env XDG_CACHE_HOME=${SRC} \
   ${IMG} \
  jupyter lab --no-browser --port=${PORT} --ip=0.0.0.0 --notebook-dir=$PBS_O_WORKDIR
