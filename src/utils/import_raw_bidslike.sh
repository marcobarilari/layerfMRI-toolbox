#!/bin/bash

## Import the raw data with bidslike name to be analysed 
#
# usage: import_raw_bidslike.sh <raw_dir> <output_dir> <subID> <sesID> <modality> <taskID> 
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

mkdir -p "${output_dir}/sub-${subID}"

if [ modality == "anat" ]; then

    find ${root_dir} -name "anat/sub-${subID}_ses-${sesID}" -exec cp {} "${output_dir}/sub-${subID}${session}" \;

else

    find ${root_dir} -name "sub-${subID}_ses-${sesID}_task-${taskID}*" -exec cp {} "${output_dir}/sub-${subID}${session}" \;

fi

gunzip -r ${output_dir}/sub-${subID}

# make sure the file is writable
chmod 777 ${output_dir}/*.nii







