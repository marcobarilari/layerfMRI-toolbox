## VASO PIPELINE - SEGMENTATION AND LAYERS

## Set up the environment
root_dir=/mnt/HD_jupiter/marcobarilari/sandbox/sandbox_layerfMRI-pipeline
raw_dir=${root_dir}/inputs/raw
derivatives_dir=${root_dir}/outputs/derivatives
code_dir=${root_dir}/code

layerfMRI_logfiles_dir=${derivatives_dir}/layerfMRI-logfiles
layerfMRI_fs_segmentation_dir=${derivatives_dir}/layerfMRI-segmentation
layerfMRI_mesh_dir=${derivatives_dir}/layerfMRI-surface-mesh
layerfMRI_layers_dir=${derivatives_dir}/layerfMRI-layers

source ${code_dir}/lib/layerfMRI-toolbox/src/config_layerfMRI_pipeline.sh

## Get raw data (bidslike files)

# Select subjet and session

subID="SC08"
sesID="02"
modality="anat"

# import_raw_bidslike.sh \
#     $raw_dir \
#     $layerfMRI_fs_segmentation_dir \
#     $subID \
#     $sesID \
#     $modality

# ## Remove the MP2RAGE noise via presurfer

# UNIT1_image=$layerfMRI_fs_segmentation_dir/sub-${subID}/sub-${subID}_ses-${sesID}_acq-r0p75_UNIT1.nii

# inv2_image=$layerfMRI_fs_segmentation_dir/sub-${subID}/sub-${subID}_ses-${sesID}_acq-r0p75_inv-2_MP2RAGE.nii

# $matlabpath -nodisplay -nosplash -nodesktop \
#     -r "UNIT1='$UNIT1_image'; \
#     INV2='$inv2_image'; \
#     addpath(genpath(fullfile('$code_dir', 'lib', 'layerfMRI-toolbox', 'src'))); \
#     run_presurfer_denoise(UNIT1, INV2); \
#     exit"

# ## Run SPM12 bias field correction via presurfer

# UNIT1_image=$layerfMRI_fs_segmentation_dir/sub-${subID}/presurf_MPRAGEise/sub-${subID}_ses-${sesID}_acq-r0p75_UNIT1_MPRAGEised.nii

# $matlabpath -nodisplay -nosplash -nodesktop \
#     -r "UNIT1='$UNIT1_image'; \
#     addpath(genpath(fullfile('$code_dir', 'lib', 'layerfMRI-toolbox', 'src'))); \
#     run_presurfer_biasfieldcorr(UNIT1); \
#     exit"

## Run freesurfer recon-all

anat_image=$layerfMRI_fs_segmentation_dir/sub-${subID}/presurf_MPRAGEise/presurf_biascorrect/sub-${subID}_ses-${sesID}_acq-r0p75_UNIT1_MPRAGEised_biascorrected.nii

filename=$anat_image
output_dir=$layerfMRI_fs_segmentation_dir/sub-${subID}/freesurfer
openmp=4

run_freesurfer_recon_all.sh \
    $anat_image \
    $layerfMRI_fs_segmentation_dir/sub-${subID}/freesurfer \
    4

## Run suma

fs_surf_path=${freesurfer_reconall_dir}/surf #sub

run_suma_fs_to_surface.sh \
    $fs_surf_path \
    $subID

## Resample anatomical

image_to_resample=
output_dir=
output_filename=
resample_factor_iso=3

resample_image_iso.sh \
    $image_to_resample \
    $output_dir \
    $output_filename \
    $resample_factor_iso

## Upsample the surface image

# Number of edge divides for linear icosahedron tesselation 
# the higehr the number the long the computation is

SUMA_dir=${fs_surf_path}

upsampled_anat=${output_dir}/${$output_filename}

# Number of edge divides for linear icosahedron tesselation 
# the higehr the number the long the computation is
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

## map_surface_to_volume_GM_WM

map_surface_to_volume_GM_WM.sh <SUMA_dir> <upsampled_anat> <subID> <linDepth> <hemisphere>

map_surface_to_volume_GM_WM.sh <SUMA_dir> <upsampled_anat> <subID> <linDepth> <hemisphere>

## Make the RIM (rim012.nii.gz) to be inspected and manually edited if necessary

combing_GM_WM.sh

## Bring the RIM to the EPI space

coregister_anat_to_epi.sh

coregister_mask_to_epi.sh

################################################################
#      VISUAL INSPECTION AND MANUAL EDITING IF NECESSARY       #
################################################################

## Make final RIM with 1 2 3 labels 

make_rim.sh

## Make layers

make_layers.sh



