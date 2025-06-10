# !bin/bash

set -e

## Combine the tissues masks and getting the rim with GM and WM
#
# usage: make_afni_GM_WM_rim.sh <SUMA_dir> <upsampled_anat> 
#                               <subID> <linDepth> <hemisphere>

print_process_logfile.sh                                                     \
    $vasopipeline_logfiles_dir                                               \
    $(basename "$0" .sh)

rim_layer_dir=$1
rim_filename=$2
linDepth=$3

echo "Combining the tissue masks and getting the rim with GM and WM"
echo ""

3dcalc                                                                       \
    -a       $rim_layer_dir/GM_rh.nii.gz                                     \
    -b       $rim_layer_dir/GM_lh.nii.gz                                     \
    -prefix  $rim_layer_dir/GM_vol.nii.gz                                    \
    -expr    'a + b '                                                        \
    -overwrite

3dcalc                                                                       \
    -a       $rim_layer_dir/supra7_pial_${linDepth}_rh.nii.gz                \
    -b       $rim_layer_dir/supra7_pial_${linDepth}_lh.nii.gz                \
    -prefix  $rim_layer_dir/pial_vol.nii.gz                                  \
    -expr    'a + b '                                                        \
    -overwrite

3dcalc                                                                       \
    -a       $rim_layer_dir/WM_rh.nii.gz                                     \
    -b       $rim_layer_dir/WM_lh.nii.gz                                     \
    -prefix  $rim_layer_dir/WM_vol.nii.gz                                    \
    -expr    'a + b'                                                        \
    -overwrite

3dcalc                                                                       \
    -a       $rim_layer_dir/WM_vol.nii.gz                                    \
    -b       $rim_layer_dir/GM_vol.nii.gz                                    \
    -c       $rim_layer_dir/pial_vol.nii.gz                                  \
    -prefix  $rim_layer_dir/$rim_filename                                    \
    -expr    'step(a)*2-step(b)-step(c)'                                     \
    -overwrite
