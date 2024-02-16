# !bin/bash

set -e

## Map back surface to volume and work on GM WM masks
#
# usage: map_surface_to_volume_GM_WM.sh <SUMA_dir> <upsampled_anat> <subID> <linDepth> <hemisphere>
#
# from https://github.com/kenshukoiso/Whole_Brain_Project/blob/main/script/s06_thinner_pial.sh

print_process_logfile.sh \
    $vasopipeline_logfiles_dir \
    map_surface_to_volume_GM_WM

SUMA_dir=$1
output_dir=$2
linDepth=$2
hemisphere

echo "working on ribbon"

3dSurf2Vol \
    -spec std_BOTH.ld${linDepth}.${hemisphere}.spec \
    -surf_A std_${hemisphere}.ld${linDepth}.${hemisphere}.smoothwm.gii \
    -surf_B std_${hemisphere}.ld${linDepth}.${hemisphere}.pial.gii \
    -sv T1.nii \
    -gridset scaled_T1.nii.gz \
    -map_func mask \
    -f_steps 40 \
    -f_index points \
    -f_p1_fr 1.05 \
    -f_pn_fr 0.1 \
    -prefix ${output_dir}/ribbonmask_${linDepth}_${hemisphere}_min_1p05_0p1.nii \
    -overwrite

echo "working on supra6_pial"

3dSurf2Vol \
    -spec std_BOTH.ld${linDepth}.${hemisphere}.spec \
    -surf_A std_${hemisphere}.ld${linDepth}.${hemisphere}.smoothwm.gii \
    -surf_B std_${hemisphere}.ld${linDepth}.${hemisphere}.pial.gii \
    -sv T1.nii \
    -gridset scaled_T1.nii.gz \
    -map_func mask \
    -f_steps 40 \
    -f_index points \
    -f_p1_fr 0.90 \
    -f_pn_fr 0.0 \
    -prefix ${output_dir}/supra6_pial_${linDepth}_${hemisphere}.nii \
    -overwrite

echo "working on supra7_pial"

3dcalc \
    -a ${output_dir}/ribbonmask_${linDepth}_${hemisphere}_min_1p05_0p1.nii \
    -b ${output_dir}/supra6_pial_${linDepth}_${hemisphere}.nii \
    -expr 'a*b' \
    -prefix ${output_dir}/supra7_pial_${linDepth}_${hemisphere}.nii

# generate GM

echo "working on GM"

# to test w/o applying any distance calculation #####
3dSurf2Vol \
    -spec std_BOTH.ld${linDepth}.${hemisphere}.spec \
    -surf_A std_${hemisphere}.ld${linDepth}.${hemisphere}.smoothwm.gii \
    -surf_B std_${hemisphere}.ld${linDepth}.${hemisphere}.pial.gii \
    -sv T1.nii \
    -gridset scaled_T1.nii.gz \
    -map_func mask \
    -f_steps 40 \
    -f_index points \
    -f_p1_fr 0.0 \
    -f_pn_fr 0.0 \
    -prefix ${output_dir}/GM_${hemisphere}.nii \
    -overwrite
#####################################################

echo "working on WM"

#remove pial by subtracting 7 supra7_pial_${linDepth}_${hemisphere} to have GM without kissing gyri
#generate WM
3dSurf2Vol \
    -spec std_BOTH.ld${linDepth}.${hemisphere}.spec \
    -surf_A std_${hemisphere}.ld${linDepth}.${hemisphere}.smoothwm.gii \
    -surf_B std_${hemisphere}.ld${linDepth}.${hemisphere}.pial.gii \
    -sv T1.nii \
    -gridset scaled_T1.nii.gz \
    -map_func mask \
    -f_steps 40 \
    -f_index points \
    -f_p1_fr -1.0 \
    -f_pn_fr 0.0 \
    -prefix ${output_dir}/WM_${hemisphere}.nii \
    -overwrite






