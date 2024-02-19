#!/bin/bash

# usage: print_process_logfile.sh <logfiles_dir> <logfile_name> <command>

logfile_name=$1
shift 2
command_to_run="$@"

mkdir -p $layerfMRI_logfiles_dir

now=`date +"%Y%m%d%H%M%S"`
logfile=${layerfMRI_logfiles_dir}/${now}_${logfile_name}.txt

echo $logfile

# Run the command and redirect its output to the log file
$command_to_run > $logfile 2>&1