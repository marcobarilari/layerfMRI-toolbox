## layerfMRI PIPELINE - STRUCTURAL TISSUE SEGMENTATION AND LAYERS DEFINITION

# This script is a demo of the layerfMRI-TOOLBOX for the tissue segmentation and layers, it runs one subject per time
#
# USAGE:
#  bash layerfMRI_pipeline_segment-layers.sh <subID>
#  where <subID> is the subject ID (e.g. SC08)
#  e.g. bash layerfMRI_pipeline_segment-layers.sh SC08
#  This script is part of the layerfMRI-TOOLBOX

set -e

# === Configure paths
# Set up the YODA folder path (YODA see the docs )
export root_dir=/home/marcobarilari/github/layerfMRI-toolbox/demos/demo_toy_data

raw_dir=${root_dir}/inputs/raw
derivatives_dir=${root_dir}/outputs/derivatives
code_dir=${root_dir}/code

export layerfMRI_toolbox_dir=${code_dir}/lib/layerfMRI-toolbox

export layerfMRI_logfiles_dir=${derivatives_dir}/layerfMRI-logfiles/sub-${subID}
layerfMRI_fs_segmentation_dir=${derivatives_dir}/layerfMRI-segmentation
layerfMRI_mesh_dir=${derivatives_dir}/layerfMRI-surface-mesh
layerfMRI_layers_dir=${derivatives_dir}/layerfMRI-layers

## Select subjet and session

subID=$1 
sesID="02"
modality="anat"

## Set up the paths
raw_dir=${root_dir}/inputs/raw
derivatives_dir=${root_dir}/outputs/derivatives

export layerfMRI_toolbox_dir=$/home/marcobarilari/github/layerfMRI-toolbox

export layerfMRI_logfiles_dir=${derivatives_dir}/layerfMRI-logfiles/sub-${subID}

layerfMRI_fs_segmentation_dir=${derivatives_dir}/layerfMRI-segmentation
layerfMRI_mesh_dir=${derivatives_dir}/layerfMRI-surface-mesh
layerfMRI_layers_dir=${derivatives_dir}/layerfMRI-layers

## Configure the layerfMRI pipeline (open this script to input your paths and preferences)
source ${layerfMRI_toolbox_dir}/config_layerfMRI_pipeline.sh 

echo "=== layerfMRI pipeline - HELLO FROM THE DOCKER IMAGE"

exit 1

# start logging mRAM memory and CPU usage (change to specific user name)
# mem_cpu_logger.sh start marcobarilari

## Get raw data (bidslike files)
import_raw_bidslike.sh \
    $raw_dir \
    $layerfMRI_fs_segmentation_dir \
    $subID \
    $sesID \
    $modality

## Remove the MP2RAGE noise via presurfer

UNIT1_image=$layerfMRI_fs_segmentation_dir/sub-${subID}/anat/sub-${subID}_ses-${sesID}_acq-r0p75_UNIT1.nii

inv2_image=$layerfMRI_fs_segmentation_dir/sub-${subID}/anat/sub-${subID}_ses-${sesID}_acq-r0p75_inv-2_MP2RAGE.nii

$matlabpath -nodisplay -nosplash -nodesktop \
    -r "UNIT1='$UNIT1_image'; \
    INV2='$inv2_image'; \
    addpath(genpath(fullfile('$code_dir', 'lib', 'layerfMRI-toolbox', 'src'))); \
    run_presurfer_denoise(UNIT1, INV2); \
    exit"

## Run SPM12 bias field correction via presurfer

UNIT1_image=$layerfMRI_fs_segmentation_dir/sub-${subID}/anat/presurf_MPRAGEise/sub-${subID}_ses-${sesID}_acq-r0p75_UNIT1_MPRAGEised.nii

$matlabpath -nodisplay -nosplash -nodesktop \
    -r "UNIT1='$UNIT1_image'; \
    addpath(genpath(fullfile('$code_dir', 'lib', 'layerfMRI-toolbox', 'src'))); \
    run_presurfer_biasfieldcorr(UNIT1); \
    exit"

## Run SPM12 brain mask extraction via presurfer

$matlabpath -nodisplay -nosplash -nodesktop \
    -r "INV2='$inv2_image'; \
    addpath(genpath(fullfile('$code_dir', 'lib', 'layerfMRI-toolbox', 'src'))); \
    run_presurfer_brainmask(INV2); \
    exit"

## Run freesurfer recon-all 
#  !!! this will take at least 5h on crunch machines

anat_image=$layerfMRI_fs_segmentation_dir/sub-${subID}/anat/presurf_MPRAGEise/presurf_biascorrect/sub-${subID}_ses-${sesID}_acq-r0p75_UNIT1_MPRAGEised_biascorrected.nii
output_dir=$layerfMRI_fs_segmentation_dir/sub-${subID}/anat
openmp=4
anat_mask=xxx

# NB: in $output_dir, freesurfer will create a folder called `freesurfer/freesurfer`
# I don't know what is the best naming option atm

run_freesurfer_recon_all.sh \
    $anat_image \
    $layerfMRI_fs_segmentation_dir/sub-${subID}/freesurfer \
    $openmp \
    $anat_mask