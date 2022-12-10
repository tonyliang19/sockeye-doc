#!/bin/bash

# Instructions to install conda environment

# 1. load dependencies and move to project location
module load gcc
module load singularity

cd /arc/project/$ALLOC/$USER/jupyter/


# 2. launch shell with jupyter/datascience-notebook container

singularity shell --home $SCRATCH_PATH \
 --env XDG_CACHE_HOME=$SCRATCH_PATH \
${PROJECT_PATH}/jupyter-datascience.sif 

# 3. create or clone conda env
# edit this `ENV_NAME`
ENV_NAME="$PROJECT_PATH/mogonet_env"

conda create --prefix $ENV_NAME python=3.7

# 4. add ipykernel module to environment
conda install -y ipykernel --prefix $ENV_NAME

# 5. Add all desired packages/modules to the environment
# - torch
conda install -y pytorch torchvision torchaudio captum cudatoolkit=10.2 -c pytorch --prefix $ENV_NAME


# 5. convert conda environment to IPython Kernel and install it for jupyter
conda run --prefix $ENV_NAME python -m ipykernel install --user --name mogonet_env


# 6. exit out of singularity image
