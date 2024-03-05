# !bin/bash

set -e

## Coregister a mask image to the distorted EPI space using a
## deformation matrix
# usage: make_afni_laynii_rim123.sh <image_to_warp> <epi_image> \
#           <mask_image> <output_dir> <output_prefix> <output_filename>

print_process_logfile.sh                                                     \
    $vasopipeline_logfiles_dir                                               \
    $(basename "$0" .sh)

input_rim=$1
output_dir=$2
output_filename=$3

# rim012 -> rim123 (LAYNII input)

3dcalc                                                                       \
    -overwrite                                                               \
    -a       $input_rim                                                      \
    -expr    'equals(a,1)'                                                   \
    -prefix  $output_dir/rimGM.nii.gz                                        \
    -datum   short

LN2_CHOLMO                                                                   \
    -layers           $output_dir/rimGM.nii.gz                               \
    -inner                                                                   \
    -nr_layers        1                                                      \
    -layer_thickness  0.44

3dcalc                                                                       \
    -overwrite                                                               \
    -a       $input_rim                                                      \
    -b       $output_dir/rimGM_padded.nii.gz                                 \
    -expr    'equals(a,0)*equals(b,1)'                                       \
    -prefix  $output_dir/rim_pial.nii.gz                                     \
    -datum   short

3dcalc                                                                       \
    -overwrite                                                               \
    -a       $input_rim                                                      \
    -b       $output_dir/rimGM_padded.nii.gz                                 \
    -expr    'equals(a,2)*equals(b,1)'                                       \
    -prefix  $output_dir/rim_WM.nii.gz                                       \
    -datum   short

3dcalc                                                                       \
    -overwrite                                                               \
    -a       $input_rim                                                      \
    -b       $output_dir/rim_pial.nii.gz                                     \
    -c       $output_dir/rim_WM.nii.gz                                       \
    -expr    'equals(a,1)*3+b+c*2'                                           \
    -prefix  $output_dir/$output_filename                                    \
    -datum   short
