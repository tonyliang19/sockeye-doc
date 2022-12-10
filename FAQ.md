# FAQ

This a file to store useful commands:
 - qstat -xf `<job-id>` : This option prints more verbose detail of your job
 - ls -l: This option prints long listing format of dir, allows you to see more details
 - ls -Art | tail -n 1: This will return the latest modified file or directory. Not very elegant, but it works.
    + -A list all files except . and ..
    + -r reverse order while sorting
    + -t sort by time, newest first