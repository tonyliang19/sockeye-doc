#!/bin/bash

# Load required modules on sockeye
module load gcc 
module load singularity

# Chance to the directory you want to store the image
# For easiness of storing files, I purposedly stored this to an extra dir 
# prior to create it

# This is the path to store the image
# You could change the name of your image
# We called it "jupyter-datascience.sif" here, .sif extension is must
IMAGE_PATH=$PROJECT_PATH/others/images

# function to pull the image
function pull_image () {

if [ -d "IMAGE_PATH" ];
then
    echo "This path does not exist yet, creating it now"
    mkdir -p $IMAGE_PATH
    cd $IMAGE_PATH
    echo "Path created at ${IMAGE_PATH} and image pulled to here"
    singularity -v pull  --force --disable-cache  --name $NAME $IMAGE_NAME
    echo "Image successfully pulled to ${IMAGE_PATH}"
else
    cd $IMAGE_PATH
    echo "Pulling image at ${IMAGE_PATH}"
    singularity -v pull  --force --disable-cache  --name $NAME $IMAGE_NAME
    echo "Image successfully pulled to ${IMAGE_PATH}"

fi
}

# check arguments provided to script
NAME=$1 IMAGE_NAME=$2 

if [[ "$#" -ne 2 ]]; then
	echo """
Usage:
	Check correct input, needs two argument
	First is the store image name
	Second is the URI from dockerhub, with this format:
		docker:://xxxx-yyy.sif
	"""
else
    pull_image
fi

