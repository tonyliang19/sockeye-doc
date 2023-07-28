#==============================================================================
# Author: Tony Liang
# Makefile saves time for repeated commands! Time matters
#==============================================================================

.SHELL=/bin/bash
.PHONY: clean build push run submit show finished_jobs job_detail

#==============================================================================
# Below is very useful for using it on sockeye, safe quite a lot of time
# Those are equivalent as if you type them in the terminal
# if you dont want to use from makefile, just have to copy command contents
# from here and prompt them in your terminal

# Submit it a job, and add a timestamp to the filename, so you
# know you dont have repeated named output files
# since each would be distinct now like below for example:
# - job-output_2023-07-25-17_15_23.txt
# - job-output_2023-07-25-17_23_15.txt

# This PBS_SRC is path to the pbs job script you want to submit
# I deafult it to the sample Rstudio one, you could replace it
# if you are submitting some other pbs script over and over
# Or just override it in runtime like
# make submit PBS_SRC=path_to_some_pbs_script
PBS_SRC ?= rstudio_pbs.sh
FILE=$(shell basename ${PBS_SRC} ".sh")
# If you dont like detailed to HH:MM:SS
# Then replace $(shell date +%Y-%m-%d_%H-%M-%S) to：
# - $(shell date +%Y-%m-%d) this shows to YYYY-MM-DD
TIMESTAMP=$(shell date +%Y-%m-%d_%H-%M-%S)
OUTPUT_NAME="${FILE}-output_${TIMESTAMP}.txt"
ERROR_NAME="${FILE}-error_${TIMESTAMP}.txt"
submit:
	@echo Submitting job now
	@echo -e "\nOutput can be found at ${OUTPUT_NAME}"
	@echo -e "Error can be found at ${ERROR_NAME}"
	@qsub -o ${OUTPUT_NAME} -e ${ERROR_NAME} ${PBS_SRC}
	@echo Submmited


# Show current running jobs
show:
	qstat -u ${USER}

# Recently finished jobs
finished_jobs:
	qstat -xf ${USER}

# View details of job providing the id
JOB_ID ?= "empty"
job_detail:
        @if [ ${JOB_ID} = "empty" ]; then \
                echo -e "You need to write the following: \
				\nmake job_detail JOB_ID=some_number"; \
        else \
                echo -e "\nChecking details of job ${JOB_ID}\n" && \
                qstat -xf ${JOB_ID} > ${JOB_ID}_details.txt && \
                echo -e "\nDetails printed to ${JOB_ID}_details.txt" ; \
        fi


#==============================================================================
# If you dont provide anything to CLEAN_DIR
# it is default to your scratch space and remove
# the following folders for you
# You could override this 'CLEAN_DIR' in runtime
# make clean CLEAN_DIR=/home/$USER
# make clean CLEAN_DIR/some_another_path
# For more explanation see the README.md

CLEAN_DIR ?=/scratch/st-singha53-1/${USER}
clean:
	rm -rf .local
	rm -rf .jupyter
	rm -rf .ipython
	rm -rf .nv
	rm -rf .cache
	@echo "\n"

#==============================================================================
# Docker related
DOCKERHUB_USERNAME ?= tonyliang19
IMAGE_NAME ?= ${DOCKERHUB_USERNAME}/sample_image
IMAGE_VERSION ?= v0.1
# Builds image and delete any dangling image (this happens when you build
# same image with same tag or version)
build:
	docker build -t ${IMAGE_NAME} -f Dockerfile .
	@(docker rmi $$(docker images -q -f dangling=true) 2>/dev/null) || \
	(echo "No image to delete" && exit 1)

# Run docker instance from image
# I default it to assume Rstudio usage it, you could replace them
# If image has jupyterlab/notebook in it
# - change to -p 8888:8888 if image has jupyter lab/notebooks
# - change to -v /$(shell pwd):/app
# If image has Rstudio in it
# - change to -p 8787:8787 if image has Rstudio
# - change to -v /$(shell pwd):/home/rstudio
# - optional -e PASSWORD=<a_password_you_like> 

run:
	docker run --rm -it \
				-e PASSWORD=a
				-v /$(shell pwd):/home/rstudio \
				-p 8888:8888 ${IMAGE_NAME}

push:
	docker push ${IMAGE_NAME}:$(IMAGE_VERSION)
#==============================================================================

