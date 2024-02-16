#!/bin/bash

set -e

## Import the raw data with bidslike name to be analysed 
#
# usage: import_raw_bidslike.sh <raw_dir> <output_dir> <subID> <sesID> <modality> <taskID> 

# get the input arguments
raw_dir=$1
output_dir=$2
subID=$3
sesID=$4
modality=$5
taskID=$6

# if no session is provided, select all
if [ -z "$sesID" ]; then
    sesID="*"
fi

# make dirs if not exist
mkdir -p ${output_dir}

mkdir -p ${output_dir}/sub-${subID}

if [[ "$modality" == "anat" ]]; then

    # copy the anata files
    find ${raw_dir} -type d -name "anat" -exec find {} -name "sub-${subID}_ses-${sesID}*.nii(.gz)" \; -exec cp -rv -L {} ${output_dir}/sub-${subID} \;

else

    # to debug
    find ${raw_dir} -type d -name "func" -exec find {} -name "sub-${subID}_ses-${sesID}*.nii(.gz)" \; -exec cp -rv -L {} ${output_dir}/sub-${subID} \;

fi

# unzip for matlab use only
gunzip -r ${output_dir}/sub-${subID}

# make sure the files are writable
chmod 777 ${output_dir}/sub-${subID}/*.nii







