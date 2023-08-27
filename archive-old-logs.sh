#!/bin/bash
# $Revision:001$
# $Sat Aug 27 15:20:34 IST 2023$

# variables
BASE=/home/user_name/archive     #give the path of directory that will store the archive
DAYS=10  # how old the file has to be, to archive that file
DEPTH=1 # for find command
RUN=0

# check if 'archive' directory is present or not
if [ ! -d $BASE ]
then 
    echo "directory does not exist: $BASE"
    exit 1
fi

# create a  'archive' directory if not already present
if [ ! -d $BASE/archive ]
then
    mkdir $BASE/archive
fi

# find all files with size more than 20MB
for i in `find $BASE -maxdepth $DEPTH -type f -size +20M  -mtime $DAYS`
do
    if [ $RUN -eq 0 ]
    then
        # message for the user
        echo "[$(data "+%Y-%m-%d %H:%M:%S)] archiving $i ==> $BASE/archive"

        # compress each file
        gzip $i || exit 1
        # move compressed files to the 'archive' folder
        mv $i.gz $BASE/archive || exit 1
    fi
done


# make a cron job to run the script every day at a given time
# in `crontab -e`
# 00 02 * * * location/of/archive-old-logs.sh


