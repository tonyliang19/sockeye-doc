# This file containts the path to store each file

There are three types of storage dir:
- Project <--- where you host large files that is used often, i.e. images, large data sets
- Scratch <--- where you mess around and store intermediate results

- Home <---- where you could have files only visible to yourself

Environment variables:
- `ALLOC=st-singha53-1` 
- `SCRATCH_PATH=/scratch/$ALLOC/$USER/work_dir` (This is the path to run stuff when running job)
- `PROJECT_PATH=/arc/project/$ALLOC/$USER` (This the path to store large files widely used for the jobs (images, containers, ...)
