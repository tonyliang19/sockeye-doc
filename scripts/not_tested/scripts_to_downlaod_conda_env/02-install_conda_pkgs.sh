#!/bin/bash

# Make sure to have the other file setup_env_vars.sh in the same directory of this file
source ./01-setup_env_vars.sh
echo $SRC

####################################################
# Install packages and make them available through ipykernel
# create a conda env with python 3.7

# RENAME if you want
NAME=torch_env
export ENV_NAME=$PRO/$NAME
# Commands to execute 
COMMANDS="conda config --set notify_outdated_conda false; \
          conda create -y --quiet --prefix ${ENV_NAME} python=3.7; \
          conda install -y ipykernel --prefix ${ENV_NAME}; \
          conda install -y pytorch torchvision torchaudio captum cudatoolkit=10.2 -c pytorch \
                --prefix ${ENV_NAME}; \
          conda run --prefix ${ENV_NAME} python -m ipykernel install --user --name $NAME"

echo "Now installing conda environment and its packages, it's gonna take a while"
apptainer exec --home $SRC \
                --env XDG_CACHE_HOME=$SRC \
                $IMG /bin/bash -c "${COMMANDS}"

echo "Done, created environment to ${ENV_NAME}"
