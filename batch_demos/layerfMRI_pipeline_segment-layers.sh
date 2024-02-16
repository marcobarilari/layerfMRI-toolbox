## VASO PIPELINE - SEGMENTATION AND LAYERS

# This script is a demo of the layerfMRI pipeline for the segmentation and layers for 1 subject only

## Set up the YODA folder path
export root_dir=/mnt/HD_jupiter/marcobarilari/sandbox/sandbox_layerfMRI-pipeline

## Select subjet and session

subID="SC08"
sesID="02"
modality="anat"

## Set up the paths
raw_dir=${root_dir}/inputs/raw
derivatives_dir=${root_dir}/outputs/derivatives
code_dir=${root_dir}/code

export layerfMRI_logfiles_dir=${derivatives_dir}/layerfMRI-logfiles
layerfMRI_fs_segmentation_dir=${derivatives_dir}/layerfMRI-segmentation
layerfMRI_mesh_dir=${derivatives_dir}/layerfMRI-surface-mesh
layerfMRI_layers_dir=${derivatives_dir}/layerfMRI-layers

## Configure the layerfMRI pipeline (open this script to input your paths and preferences)
source ${code_dir}/lib/layerfMRI-toolbox/config_layerfMRI_pipeline.sh

## Get raw data (bidslike files)
import_raw_bidslike.sh \
    $raw_dir \
    $layerfMRI_fs_segmentation_dir \
    $subID \
    $sesID \
    $modality

## Remove the MP2RAGE noise via presurfer

UNIT1_image=$layerfMRI_fs_segmentation_dir/sub-${subID}/sub-${subID}_ses-${sesID}_acq-r0p75_UNIT1.nii

inv2_image=$layerfMRI_fs_segmentation_dir/sub-${subID}/sub-${subID}_ses-${sesID}_acq-r0p75_inv-2_MP2RAGE.nii

$matlabpath -nodisplay -nosplash -nodesktop \
    -r "UNIT1='$UNIT1_image'; \
    INV2='$inv2_image'; \
    addpath(genpath(fullfile('$code_dir', 'lib', 'layerfMRI-toolbox', 'src'))); \
    run_presurfer_denoise(UNIT1, INV2); \
    exit"

## Run SPM12 bias field correction via presurfer

UNIT1_image=$layerfMRI_fs_segmentation_dir/sub-${subID}/presurf_MPRAGEise/sub-${subID}_ses-${sesID}_acq-r0p75_UNIT1_MPRAGEised.nii

$matlabpath -nodisplay -nosplash -nodesktop \
    -r "UNIT1='$UNIT1_image'; \
    addpath(genpath(fullfile('$code_dir', 'lib', 'layerfMRI-toolbox', 'src'))); \
    run_presurfer_biasfieldcorr(UNIT1); \
    exit"

## Run freesurfer recon-all 
#  !!! this will take at least 5h on crunch machines

anat_image=$layerfMRI_fs_segmentation_dir/sub-${subID}/presurf_MPRAGEise/presurf_biascorrect/sub-${subID}_ses-${sesID}_acq-r0p75_UNIT1_MPRAGEised_biascorrected.nii
output_dir=$layerfMRI_fs_segmentation_dir/sub-${subID}
openmp=1

# NB: in $output_dir, freesurfer will create a folder called `freesurfer/freesurfer`
# I don't know what is the best naming option atm

run_freesurfer_recon_all.sh \
    $anat_image \
    $layerfMRI_fs_segmentation_dir/sub-${subID}/freesurfer \
    $openmp

## Run suma reconstruction 

fs_surf_path=$layerfMRI_fs_segmentation_dir/sub-${subID}/freesurfer/freesurfer/surf
suma_output_dir=$layerfMRI_mesh_dir/sub-${subID}

run_suma_fs_to_surface.sh \
    $fs_surf_path \
    $suma_output_dir \
    sub-$subID

## Resample anatomical
#  The image will used as a reference for the resampling of the surface 
#  images

image_to_resample=$suma_output_dir/SUMA/T1.nii.gz
output_dir=$suma_output_dir
output_filename=sub-${subID}_ses-${sesID}_res-r0p25_UNIT1_MPRAGEised_biascorrected_fromFS.nii.gz
resample_factor_iso=3

resample_afni_image_iso.sh \
    $image_to_resample \
    $output_dir \
    $output_filename \
    $resample_factor_iso

## Upsample the surface image 
#  !!! with `linDepth=2000` this will take long time (up to 4h) and a hog memory (up 40 GB) *per hemisphere*
#  !!! to make the process faster you can run the two hemispheres in parallel in separate terminals
#  !!! if in linux, consider increasesing the swap memory.

suma_dir=$layerfMRI_mesh_dir/sub-${subID}/SUMA
upsampled_anat=$suma_dir/sub-${subID}_ses-${sesID}_res-r0p25_UNIT1_MPRAGEised_biascorrected_fromFS.nii.gz

# Number of edge divides for linear icosahedron tesselation 
# the higher the number, the longer the computation
# Suggested values: 2000 for high resolution, 100 for debugging
linDepth=100 

hemisphere="lh"

upsample_suma_surface.sh \
    $suma_dir \
    $upsampled_anat \
    $subID \
    $linDepth \
    $hemisphere

hemisphere="rh"

upsample_suma_surface.sh \
    $suma_dir \
    $upsampled_anat \
    $subID \
    $linDepth \
    $hemisphere

## Convert segmentated tissue from surface to volume maks

suma_dir=$layerfMRI_mesh_dir/sub-${subID}/SUMA
upsampled_anat=$layerfMRI_mesh_dir/sub-${subID}/sub-${subID}_ses-${sesID}_res-r0p25_UNIT1_MPRAGEised_biascorrected_fromFS.nii.gz
output_dir=$layerfMRI_layers_dir/sub-${subID}

# Number of edge divides for linear icosahedron tesselation 
# the higher the number, the longer the computation
# Suggested values: 2000 for high resolution, 100 for debugging
linDepth=100 

hemisphere="lh"

convert_afni_surface_to_volume_tissue_mask.sh \
    $suma_dir \
    $output_dir \
    $upsampled_anat \
    $subID \
    $linDepth \
    $hemisphere

hemisphere="rh"

convert_afni_surface_to_volume_tissue_mask.sh \
    $suma_dir \
    $output_dir \
    $upsampled_anat \
    $subID \
    $linDepth \
    $hemisphere


# BELOW HERE IS WIP, MIGHT EXPLODE #################################

echo "Aborting since next steps are not debugged yet"
exit 1

## Make the RIM (rim012.nii.gz) to be inspected and manually edited if necessary

combing_GM_WM.sh

################################################################
#      VISUAL INSPECTION AND MANUAL EDITING IF NECESSARY       #
################################################################

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



