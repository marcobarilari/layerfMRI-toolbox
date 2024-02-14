#!/bin/bash

set -e

## print the outpout of this script into a logfile.txt file
#
# usage: print_process_logfile.sh <logfiles_dir> <logfile_name>

logfiles_dir=$1
logfile_name=$2

make -p ${logfiles_dir}

if [ -z "$SCRIPT_LOG_FILE" ]
then 

    var=`date +"%FORMAT_STRING"`
    now=`date +"%Y%m%d%H%M%S"`

    logfile=${logfiles_dir}/${logfile_name}_${now}.txt

    export SCRIPT_LOG_FILE=$logfile

    /usr/bin/script $logfile /bin/bash -c "$0 $*"
        
    exit 0

fi