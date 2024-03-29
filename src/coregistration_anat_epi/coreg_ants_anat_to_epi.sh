# !bin/bash

set -e

## Coregister an anatomical image to the distorted EPI space
#
# usage: coreg_ants_anat_to_epi.sh <image_to_warp> <epi_image> <mask_image> <output_dir> <output_prefix> <output_filename>

print_process_logfile.sh \
    $vasopipeline_logfiles_dir \
     $(basename "$0" .sh)

image_to_warp=$1
epi_image=$2
mask_image=$3
output_dir=$4
output_prefix=$5
# output_filename=$6

if [ ! -f "$image_to_warp" ]; then
    echo ""
    echo "Image to warp does not exists"
    echo ""
    exit 1 
fi

if [ ! -f "$epi_image" ]; then
    echo ""
    echo "EPI reference does not exists"
    echo ""
    exit 1 
fi

if [ ! -f "$mask_image" ]; then
    echo ""
    echo "Mask image does not exists"
    echo ""
    exit 1 
fi

if [ ! -d "$output_dir" ]; then
    echo ""
    echo "The directory where yo uwant to save the output does not exists"
    echo ""
    exit 1 
fi

antsRegistration \
    --verbose 1 \
    --dimensionality 3 \
    --float 0 \
    --output "["${output_dir}"/"${output_prefix}"_,"${output_dir}"/"${output_prefix}"_Warped.nii.gz,"${output_dir}"/"${output_prefix}"_InverseWarped.nii.gz]" \
    --interpolation Linear \
    --use-histogram-matching 0 \
    --winsorize-image-intensities "[0.005,0.995]" \
    --transform "Rigid[0.05]" \
    --metric "MI["${epi_image}","${image_to_warp}",0.7,32,Regular,0.1]" \
    --convergence "[1000x500,1e-6,10]" \
    --shrink-factors "2x1" \
    --smoothing-sigmas "1x0vox" \
    --transform "Affine[0.1]" \
    --metric "MI["${epi_image}","${image_to_warp}",0.7,32,Regular,0.1]" \
    --convergence "[1000x500,1e-6,10]" \
    --shrink-factors "2x1" \
    --smoothing-sigmas "1x0vox" \
    --transform "SyN[0.1,3,0]" \
    --metric "CC["${epi_image}","${image_to_warp}",1,4]" \
    --convergence "[100x70x50x20,1e-6,10]" \
    --shrink-factors "4x4x2x1" \
    --smoothing-sigmas "3x2x1x0vox" \
    -x "${mask_image}"
