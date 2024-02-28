## VASO PIPELINE - SEGMENTATION AND LAYERS

# This script is a demo of the layerfMRI pipeline for the segmentation
# and layers for 1 subject only

# ver = 1.0
# ============================================================================

## Set up the YODA folder path
export root_dir=/mnt/HD_jupiter/marcobarilari/sandbox/sandbox_layerfMRI-pipeline

## Select subject and session

subID="SC08"
sesID="02"
modality="anat"

subj=sub-${subID}
ses=ses-${sesID}

## Set up the paths
raw_dir=${root_dir}/inputs/raw
deriv_dir=${root_dir}/outputs/derivatives
code_dir=${root_dir}/code
export layerfMRI_toolbox_dir=${code_dir}/lib/layerfMRI-toolbox

export layerfMRI_logfiles_dir=${deriv_dir}/layerfMRI-logfiles/${subj}
lfmri_fs_seg_dir=${deriv_dir}/layerfMRI-segmentation
lfmri_mesh_dir=${deriv_dir}/layerfMRI-surface-mesh
lfmri_layers_dir=${deriv_dir}/layerfMRI-layers

## Configure the layerfMRI pipeline (open this script to input your
## paths and preferences)
source ${code_dir}/lib/layerfMRI-toolbox/config_layerfMRI_pipeline.sh 

mem_cpu_logger.sh start marcobarilari

## Get raw data (bidslike files)
import_raw_bidslike.sh                                                        \
    $raw_dir                                                                  \
    $lfmri_fs_seg_dir                                                         \
    $subID                                                                    \
    $sesID                                                                    \
    $modality

## Remove the MP2RAGE noise via presurfer

anat_dir=$lfmri_fs_seg_dir/${subj}/anat
UNIT1_image=${anat_dir}/${subj}_${ses}_acq-r0p75_UNIT1.nii
inv2_image=${anat_dir}/${subj}_${ses}_acq-r0p75_inv-2_MP2RAGE.nii

$matlabpath -nodisplay -nosplash -nodesktop                                   \
    -r "UNIT1='$UNIT1_image';                                                 \
    INV2='$inv2_image';                                                       \
    addpath(genpath(fullfile('$code_dir','lib','layerfMRI-toolbox','src')));  \
    run_presurfer_denoise(UNIT1, INV2);                                       \
    exit"

## Run SPM12 bias field correction via presurfer

UNIT1_image=${anat_dir}/presurf_MPRAGEise/${subj}_${ses}_acq-r0p75_UNIT1_MPRAGEised.nii

$matlabpath -nodisplay -nosplash -nodesktop                                   \
    -r "UNIT1='$UNIT1_image';                                                 \
    addpath(genpath(fullfile('$code_dir','lib','layerfMRI-toolbox','src')));  \
    run_presurfer_biasfieldcorr(UNIT1); \
    exit"

# ## Run freesurfer recon-all 
# #  ***this will take at least 5h on crunch machines***

anat_image=${anat_dir}/presurf_MPRAGEise/presurf_biascorrect/${subj}_${ses}_acq-r0p75_UNIT1_MPRAGEised_biascorrected.nii
output_dir=${anat_dir}
openmp=4

# NB: in $output_dir, freesurfer will create a folder called
# `freesurfer/freesurfer`. 
# I don't know what is the best naming option atm

run_freesurfer_recon_all.sh                                                   \
    $anat_image                                                               \
    $lfmri_fs_seg_dir/${subj}/freesurfer                                 \
    $openmp

## Run suma reconstruction 

fs_surf_path=$lfmri_fs_seg_dir/${subj}/freesurfer/freesurfer/surf
suma_output_dir=$lfmri_mesh_dir/${subj}

run_suma_fs_to_surface.sh                                                     \
    $fs_surf_path                                                             \
    $suma_output_dir                                                          \
    ${subj}

## Resample anatomical
#  The image will used as a reference for the resampling of the surface 
#  images

image_to_resample=$suma_output_dir/SUMA/T1.nii.gz
output_dir=$suma_output_dir
output_filename=${subj}_${ses}_res-r0p25_UNIT1_MPRAGEised_biascorrected_fromFS.nii.gz
resample_iso_factor=3

resample_afni_image_iso_factor.sh                                             \
    $image_to_resample                                                        \
    $output_dir                                                               \
    $output_filename                                                          \
    $resample_iso_factor

## Upsample the surface image 
#  *** with `linDepth=2000` this will take long time (up to 4h) and a hog 
#      memory (up 40 GB) *per hemisphere*
#  *** to make the process faster you can run the two hemispheres in parallel
#      in separate terminals
#  *** if in linux, consider increasesing the swap memory.

suma_dir=$lfmri_mesh_dir/${subj}/SUMA
upsampled_anat=$suma_dir/${subj}_${ses}_res-r0p25_UNIT1_MPRAGEised_biascorrected_fromFS.nii.gz

# Number of edge divides for linear icosahedron tesselation 
# (the higher the number, the longer the computation).
# Suggested values: 2000 for high resolution, 100 for debugging
linDepth=2000

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

suma_dir=$lfmri_mesh_dir/${subj}/SUMA
upsampled_anat=$lfmri_mesh_dir/${subj}/${subj}_${ses}_res-r0p25_UNIT1_MPRAGEised_biascorrected_fromFS.nii.gz
output_dir=$lfmri_layers_dir/${subj}

# Number of edge divides for linear icosahedron tesselation 
# the higher the number, the longer the computation
# Suggested values: 2000 for high resolution, 100 for debugging
# linDepth=100 

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
#  the outout is rim012.nii.gz to be visually inspected and manually edited 
#  if necessary
#  You might consider to first align it to EPI space and then manually edit it
#  and then make the final rim and make layers in the next steps

rim_layer_dir=$lfmri_layers_dir/${subj}
rim_filename=rim012.nii.gz
# linDepth=100 

make_afni_GM_WM_rim.sh \
    $rim_layer_dir \
    $rim_filename \
    $linDepth

################################################################
#      VISUAL INSPECTION AND MANUAL EDITING IF NECESSARY       #
################################################################

## Move images to  EPI distorted space

# Move anatomical to EPI space

image_to_warp=${anat_dir}/presurf_MPRAGEise/presurf_biascorrect/${subj}_${ses}_acq-r0p75_UNIT1_MPRAGEised_biascorrected.nii
epi_image=$raw_dir/${subj}/${ses}/anat/${subj}_${ses}_space-epi_T1w.nii.gz
mask_image=$raw_dir/${subj}/${ses}/roi/${subj}_bubble_rMT.nii.gz
output_dir=$lfmri_layers_dir/${subj}
output_prefix=ANTs
output_filename=${subj}_space-EPI_UNIT1.nii.gz

export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=8

coreg_ants_anat_to_epi.sh \
    $image_to_warp \
    $epi_image \
    $mask_image \
    $output_dir \
    $output_prefix

# Upsample the T1w image extracted from vaso

image_to_resample=$raw_dir/${subj}/${ses}/anat/${subj}_${ses}_space-epi_T1w.nii.gz
output_dir=$lfmri_layers_dir/${subj}
output_filename=${subj}_${ses}_space-epi_res-0p25_T1w.nii.gz
resample_iso_factor=3

resample_ants_image_iso_factor.sh \
    $image_to_resample \
    $output_dir \
    $output_filename \
    $resample_iso_factor

# Move mask/rim to EPI space
# Move rim012 to epi space for manual editing and then reacting final rim and layers

mask_to_warp=$lfmri_layers_dir/${subj}/rim012.nii.gz
epi_image_upsampled=$lfmri_layers_dir/${subj}/${subj}_${ses}_space-epi_res-0p25_T1w.nii.gz
MTxfm=$lfmri_layers_dir/${subj}/ANTs_1Warp.nii.gz
MTgenericAffine=$lfmri_layers_dir/${subj}/ANTs_0GenericAffine.mat
output_dir=$lfmri_layers_dir/${subj}/
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

input_rim=$lfmri_layers_dir/${subj}/rim012_space-EPI.nii.gz
output_dir=$lfmri_layers_dir/${subj}
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

input_rim123=$lfmri_layers_dir/${subj}/rim123_space-EPI.nii.gz
nb_layers=7
output_dir=$lfmri_layers_dir/${subj}
output_filename=${subj}_sapce-EPI"${mask_roi}"_desc-"${desc}".nii.gz

make_laynii_layers.sh \
    $input_rim123 \
    $nb_layers \
    $output_dir \
    $output_filename

mem_cpu_logger.sh stop marcobarilari
