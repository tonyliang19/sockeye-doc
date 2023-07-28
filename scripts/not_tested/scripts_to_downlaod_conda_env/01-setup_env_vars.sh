#!/bin/bash

# function to check path exists , otherwise creates it
function make_dir {
    if [ ! -d $1 ];
    then
        mkdir -pv $1
    fi
}


# Useful Paths and envs
# Allocation
ALLOC=st-singha53-1
# Rename this is you want #######################
PROJ_NAME=test_project
#########################################################################
# paths to use in apptainer
SRC=/scratch/${ALLOC}/${USER}/$PROJ_NAME
PRO=/arc/project/${ALLOC}/$USER/$PROJ_NAME
# creating them
make_dir ${SRC} && make_dir ${PRO}
# Export this for later usage
export SRC
export PRO
export ALLOC

#########################################################################
# load required modules
module load gcc apptainer
# pull image to path specified
URL=jupyter/datascience-notebook
# RENAME if you want
IMG_NAME=jup-ntb
IMG=${PRO}/${IMG_NAME}.sif
if [ ! -f ${IMG} ]
then
    echo "Pulling image now and installing to ${IMG}"
    apptainer pull --name ${IMG} docker://${URL}
fi

export IMG

echo "Done pulling image, now to download conda environment and packages"
