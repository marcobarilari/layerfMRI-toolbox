# !bin/bash

set -e

## Run freesurfer recon-all for high-res data
#
# usage: run_freesurfer_recon_all.sh <filename> <output_dir> <openmp>

# no need to print out the recon-all logfile since freesurfer takes care of it
# you can find it in <freesurfer-output>/scripts/recon-all.log
# print_process_logfile.sh

source config_layerfMRI_pipeline.sh

filename=$1
output_dir=$2
openmp=$3

recon-all -all \
    -s /"${resID}" \
    -hires \
    -i ${filename}} \
    -expert expert.opts \
    -parallel -openmp $openmp