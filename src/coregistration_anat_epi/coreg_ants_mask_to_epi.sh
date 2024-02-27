# !bin/bash

set -e

## Coregister a mask image to the distorted EPI space using a deforamtion matrix
#
# usage: coreg_ants_mask_to_epi.sh <image_to_warp> <epi_image> <mask_image> <output_dir> <output_prefix> <output_filename>

print_process_logfile.sh \
    $vasopipeline_logfiles_dir \ 
    $(basename "$0" .sh)

mask_to_warp=$1
reference_image=$2
MTxfm=$3
MTgenericAffine=$4
output_dir=$5
output_filename=$6

if [ ! -f "$mask_to_warp" ]; then
    echo ""
    echo "Mask image to warp does not exists"
    echo ""
    exit 1 
fi

if [ ! -f "$reference_image" ]; then
    echo ""
    echo "Reference image does not exists"
    echo ""
    exit 1 
fi

if [ ! -f "$MTxfm" ]; then
    echo ""
    echo "Transforamtion matrix MTxfm does not exists"
    echo ""
    exit 1 
fi

if [ ! -f "$MTgenericAffine" ]; then
    echo ""
    echo "Transforamtion matrix MTgenericAffine does not exists"
    echo ""
    exit 1 
fi

if [ ! -d "$output_dir" ]; then
    echo ""
    echo "Mask image does not exists"
    echo ""
    exit 1 
fi

antsApplyTransforms \
    --interpolation "MultiLabel" \
    --dimensionality 3 \
    --input $mask_to_warp \
    --reference-image $reference_image \
    --transform $MTxfm \
    --transform $MTgenericAffine \
    --output $output_dir/$output_filename \
    --verbose 1