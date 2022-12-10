# This is a script to clear/or print latest connection files you have

# PATH to the connections DIR
CON_DIR=$SCRATCH_PATH/others/links/

# check if CON_DIR exists
if [[ ! -d "$CON_DIR" ]];
then
    echo "Directory does not exist, check if you provided wrong dir?"	
fi

#clear all connections or print the latest file
cd $CON_DIR

if [[ ! $(ls -Art | tail -n 1) ]];
then
 echo "You dont have any files yet"
else
    FILE=$(ls -Art | tail -n 1)
    echo "This is the newest file created: "
    echo $FILE
    # ask to delete or not cat i
    echo "Print (p) or Delete (d) ?"
    read CONTROL

    if [[ $CONTROL = d ]];
    then
      echo "Deleting files"
      rm $CON_DIR/*
    else
      echo "Printing the connection file"
      cat $FILE 
    fi
fi




