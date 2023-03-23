# Instruction to install package

## Include a script or code to intsall base container of your choice

Preferably, make this inside your project path:

```bash

# $PROJECT PATH is /arc/project/<st-alloc-1>/
mkdir $PROJECT_PATH/images/<category_of_image>

export IMAGE_PATH=$PROJECT_PATH/images/<categ   ory_of_image>

# move to that dir
cd  $IMAGE_PATH


# Note this is only available in LOGIN NODE
# build sandbox container

# first arg is name of container with .sandbox extension
# second arg is docker://registry/image_name
apptainer build --sandbox <name>.sandbox docker://rocker/[rstudio | tidyverse | any other image]
# CAREFUL WITH THIS ONE ^^^^ TAKES LONG TIME TO, its literally downloading whole space down and not .sif

```

Then you could mess around with that `sandbox` with following:

```bash
# go to your image dir
cd $IMAGE_PATH

# makes interactive shell of the sandbox and allows you to install anything there
apptainer shell --writable --fakeroot <image.sandbox>
```
