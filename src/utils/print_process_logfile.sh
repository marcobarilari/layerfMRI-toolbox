#!/bin/bash

## print the outpout of this script into a logfile.txt file
#
# usage: print_process_logfile.sh $(basename "$0" .sh)
# $(basename "$0" .sh) - if called within a script, it will print the name of the script without the .sh extension

logfile_name=$1

mkdir -p $layerfMRI_logfiles_dir

if [ -z "$SCRIPT_LOG_FILE" ]
then 

    var=`date +"%FORMAT_STRING"`
    now=`date +"%Y%m%d%H%M%S"`

    logfile=${layerfMRI_logfiles_dir}/${now}_${logfile_name}.txt

    # Redirect stdout (standard output) and stderr (standard error) to the log file
    # exec > $logfile 2>&1

    export SCRIPT_LOG_FILE=$logfile

    /usr/bin/script -f -c "/bin/bash $0 $*" $logfile 

    exit 0

fi