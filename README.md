# UBC ARC Sockeye Documentation Cheat Sheet

By: Tony Liang

This is a documentaion for setup singularity container + conda environment on sockeye ARC, for full reference see [here](https://confluence.it.ubc.ca/display/UARC/Quickstart+Guide#QuickstartGuide-ConnectingtoSockeye)


Table of Contents:
 1. [Sockeye and its environment](#sockeye-and-its-environment)
 2. [Setup a singularity container](#setup-a-singularity-container)
 3. [Setup a conda environment](#setup-a-conda-environment)
 4. [Running jobs to spawn your container](#running-jobs-to-spawn-your-container)

## Sockeye and its environment

Sockeye is a computing platform that uses PBS as its job manager instead of SLURM, hence for the documentation of how to submit PBS jobs and specifying options, please see [here](PBSUserGuide2022.1.pdf)

Things you should know:

- Once you ssh into the platform, your pwd likely to be: `/home/$USER`, whereas `$USER` is default environment variable and you should also have `ALLOC=the allocation code`, if not defined you could add it to `~/.bash_profile`.
- You will be working in two main directories: `/arc/project/$ALLOC/$USER` or `/scratch/$ALLOC/$USER`. The first one is to store final results/outputs of your works, the latter one for all other purposes, and recommended to use for experiments. **NOTE**: Defining the two paths into two env would ease your life much.
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


placeholder

## Setup a conda environment

placeholder

## Running jobs to spawn your container

placeholder
