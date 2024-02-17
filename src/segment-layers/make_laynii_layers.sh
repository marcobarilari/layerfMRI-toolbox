# !bin/bash

set -e

## Coregister a mask image to the distorted EPI space using a deforamtion matrix
#
# usage: make_laynii_layres.sh <image_to_warp> <epi_image> <mask_image> <output_dir> <output_prefix> <output_filename>

print_process_logfile.sh \
    $vasopipeline_logfiles_dir \
     $(basename "$0" .sh)

input_rim123=$1
nb_layers=$2
output_dir=$3
output_filename=$4

LN2_LAYERS \
    -rim $input_rim123 \
    -nr_layers $nb_layers \
    -equivol \
    -thickness \
    -equal_counts \
    -incl_borders \
    -output $output_dir/$output_filename
