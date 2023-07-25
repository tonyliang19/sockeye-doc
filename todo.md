# Todo LOG

Place to store todos, future implementation. For more logistic stuff, refer to the [README](README.md)

### Makefile

- Install program with make, i.e. compiled with cc.
- Run repeated steps with make:
    + submit job
    + build/run docker
    + clean "garbage" , or hidden files

### PBS scripts

- Detailed instruction on what to modify from a template file
- Resource allocation strategy
- Merged error and output file, add a timestamp to it  
    + combine it with Makefile, so it could be applied by providing CLI arg for script to use, need to provided arg to override name of the job as well
- Remind to submit job only from **SCRATCH**, if output is to be written, redirect to **SCRATCH** as well. Then manually transfer it to `PROJECT`