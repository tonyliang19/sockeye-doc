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

fi
