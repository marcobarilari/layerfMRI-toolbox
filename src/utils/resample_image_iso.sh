# !bin/bash

set -e

## Upsample any image by a factor
#
# usage: resample_image.sh <image_to_resample> <output_dir> <output_filename> <resample_factor_iso>

print_process_logfile.sh \
    $vasopipeline_logfiles_dir \
    resample-image

image_to_resample=$1
output_dir=$2
output_filename=$3
resample_factor_iso=$4

delta_x=$(3dinfo -di $image_to_resample)
delta_y=$(3dinfo -dj $image_to_resample)
delta_z=$(3dinfo -dk $image_to_resample)

sdelta_x=$(echo "((sqrt($delta_x * $delta_x) / $resample_factor))"|bc -l)
sdelta_y=$(echo "((sqrt($delta_y * $delta_y) / $resample_factor))"|bc -l)
sdelta_z=$(echo "((sqrt($delta_z * $delta_z) / $resample_factor))"|bc -l)

echo "$sdelta_x"
echo "$sdelta_y"
echo "$sdelta_z"

3dresample \
    -dxyz $sdelta_x $sdelta_y $sdelta_z \
    -rmode Bk \
    -overwrite \
    -prefix ${output_dir}/${output_filename} \
    -input $image_to_resample