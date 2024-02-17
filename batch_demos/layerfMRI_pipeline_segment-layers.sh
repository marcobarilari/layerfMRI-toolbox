## VASO PIPELINE - SEGMENTATION AND LAYERS

mem_cpu_lloger.sh start marcobarilari

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

export layerfMRI_logfiles_dir=${derivatives_dir}/layerfMRI-logfiles/sub-${subID}
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
resample_iso_factor=3

resample_afni_image_iso_factor.sh \
    $image_to_resample \
    $output_dir \
    $output_filename \
    $resample_iso_factor

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

## Make the RIM to be inspected and manually edited if necessary
#  the outout is rim012.nii.gz to be visually inspected and manually edited if necessary
#  You might cosnider to first align it to EPI space and then manually edit it
#  and then make the final rim and make layers in the next steps

rim_layer_dir=$layerfMRI_layers_dir/sub-${subID}
rim_filename=rim012.nii.gz
linDepth=100 

make_afni_GM_WM_rim.sh \
    $rim_layer_dir \
    $rim_filename \
    $linDepth

################################################################
#      VISUAL INSPECTION AND MANUAL EDITING IF NECESSARY       #
################################################################

## Move images to  EPI distorted space

# Move anatomical to EPI space

image_to_warp=$layerfMRI_fs_segmentation_dir/sub-${subID}/presurf_MPRAGEise/presurf_biascorrect/sub-${subID}_ses-${sesID}_acq-r0p75_UNIT1_MPRAGEised_biascorrected.nii
epi_image=$layerfMRI_fs_segmentation_dir/sub-${subID}/sub-${subID}_T1_weighted.nii.gz
mask_image=$raw_dir/sub-SC08/ses-02/roi/bubble_MT_rh.nii.gz
output_dir=$layerfMRI_layers_dir/sub-${subID}
output_prefix=ANTs
output_filename=sub-${subID}_space-EPI_UNIT1.nii.gz

coreg_ants_anat_to_epi.sh \
    $image_to_warp \
    $epi_image \
    $mask_image \
    $output_dir \
    $output_prefix

# Upsample the T1w image extracted from vaso

image_to_resample=$layerfMRI_fs_segmentation_dir/sub-${subID}/sub-${subID}_T1_weighted.nii.gz
output_dir=$layerfMRI_layers_dir/sub-${subID}
output_filename=sub-${subID}_res-0p25_T1w.nii.gz
resample_iso_factor=3

resample_ants_image_iso_factor.sh \
    $image_to_resample \
    $output_dir \
    $output_filename \
    $resample_iso_factor


# Move mask/rim to EPI space
# Move rim012 to epi space for manual editing and then reacting final rim and layers

mask_to_warp=$layerfMRI_layers_dir/sub-${subID}/rim012.nii.gz
epi_image_upsampled=$layerfMRI_layers_dir/sub-${subID}/sub-${subID}_res-0p25_T1w.nii.gz
MTxfm=$layerfMRI_layers_dir/sub-${subID}/ANTs_1Warp.nii.gz
MTgenericAffine=$layerfMRI_layers_dir/sub-${subID}/ANTs_0GenericAffine.mat
output_dir=$layerfMRI_layers_dir/sub-${subID}/
output_filename=rim012_space-EPI.nii.gz

coreg_ants_mask_to_epi.sh \
    $mask_to_warp \
    $epi_image_upsampled \
    $MTxfm \
    $MTgenericAffine \
    $output_dir \
    $output_filename

################################################################
#      VISUAL INSPECTION AND MANUAL EDITING IF NECESSARY       #
################################################################

## Make final RIM with 1 2 3 labels 

input_rim=$layerfMRI_layers_dir/sub-${subID}/rim012_space-EPI.nii.gz
output_dir=$layerfMRI_layers_dir/sub-${subID}
output_filename=rim123_space-EPI.nii.gz


make_afni_laynii_rim123.sh \
    $input_rim \
    $output_dir \
    $output_filename



################################################################
#      VISUAL INSPECTION AND MANUAL EDITING IF NECESSARY       #
################################################################

## Make layers

mask_roi="rightMT"
desc="7layers"

input_rim123=$layerfMRI_layers_dir/sub-${subID}/rim123_space-EPI.nii.gz
nb_layers=7
output_dir=$layerfMRI_layers_dir/sub-${subID}
output_filename=sub-${subID}_sapce-EPI"${mask_roi}"_desc-"${desc}".nii.gz

make_laynii_layers.sh \
    $input_rim123 \
    $nb_layers \
    $output_dir \
    $output_filename




mem_cpu_lloger.sh stop marcobarilari
