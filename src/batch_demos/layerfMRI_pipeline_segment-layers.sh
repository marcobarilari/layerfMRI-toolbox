## VASO PIPELINE - SEGMENTATION AND LAYERS

## Set up the environment
root_dir=/Volumes/PAUL/datalad/analysis_high-res_BLAM_NIH_vaso_sandbox
raw_dir=${root_dir}/inputs/raw
derivatives_dir=${root_dir}/derivatives_layerfMRI-toolbox
code_dir=${root_dir}/code

vasopipeline_logfiles_dir=${derivatives_dir}/vasopipeline-logfiles
freesurfer_reconall_dir=${derivatives_dir}/freesurfer-reconall
vasopipeline_mesh_dir=${derivatives_dir}/vasopipeline-surface-mesh
vasopipeline_layers_dir=${derivatives_dir}/vasopipeline-layers

source ${code_dir}/src/pipeline/config_layerfMRI_pipeline.sh

## Get raw data (bidslike files)

# Select subjet and session to convert

subID="SC04"
sesID="02"

## Run presurfer

## Run freesurfer

run_freesurfer_recon_all.sh

## Run suma

fs_surf_path=${freesurfer_reconall_dir}/surf #sub

run_suma_fs_to_surface.sh $fs_surf_path $subID

## Resamle anatomical

image_to_resample=
output_dir=
output_filename=
resample_factor_iso=3

resample_image_iso.sh \
    $image_to_resample \
    $output_dir \
    $output_filename \
    $resample_factor_iso

## Run surf to vol

# Number of edge divides for linear icosahedron tesselation 
# the higehr the number the long the computation is

SUMA_dir=${fs_surf_path}
upsampled_anat=

linDepth=2000

hemisphere="lh"

upsample_SUMA_surface.sh \
    $SUMA_dir \
    $upsampled_anat
    $subID \
    $linDepth \
    $hemisphere

hemisphere="rh"

upsample_SUMA_surface.sh \
    $SUMA_dir \
    $upsampled_anat
    $subID \
    $linDepth \
    $hemisphere