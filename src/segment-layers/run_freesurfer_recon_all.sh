# !bin/bash

# set -e

## Run freesurfer recon-all for high-res data
#
# usage: run_freesurfer_recon_all.sh <filename> <output_dir> <openmp>

# no need to print out the recon-all logfile since freesurfer takes care of it
# you can find it in <freesurfer-output>/scripts/recon-all.log
# print_process_logfile.sh 'recon-all'

source config_layerfMRI_pipeline.sh

filename=$1
output_dir=$2
openmp=$3

echo $filename
echo $output_dir
echo $openmp


rm -rf $output_dir
mkdir -p $output_dir

echo $layerfmri_toolbox_dir

# recon-all -all \
#     -s $output_dir \
#     -hires \
#     -i $filename \
#     -expert expert.opts \ # add path?
#     -parallel -openmp $openmp


# recon-all -all \
#     -s /mnt/HD_jupiter/marcobarilari/sandbox/sandbox_layerfMRI-pipeline/outputs/derivatives/layerfMRI-segmentation/sub-SC08/freesurfer \
#     -hires \
#     -i /mnt/HD_jupiter/marcobarilari/sandbox/sandbox_layerfMRI-pipeline/outputs/derivatives/layerfMRI-segmentation/sub-SC08/presurf_MPRAGEise/presurf_biascorrect/sub-SC08_ses-02_acq-r0p75_UNIT1_MPRAGEised_biascorrected.nii \
#     -expert $layerfmri_toolbox_dir/src/segment-layers/expert.opts \
#     -parallel -openmp 4