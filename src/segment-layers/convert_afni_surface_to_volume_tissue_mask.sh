# !bin/bash

set -e

## Map back surface to volume and work on GM WM masks
#
# usage: convert_surface_to_volume_tissue_mask.sh <SUMA_dir> 
#                <upsampled_anat> <subID> <linDepth> <hemisphere>
#
# Adapted from https://github.com/kenshukoiso/Whole_Brain_Project/blob/main/script/s06_thinner_pial.sh

print_process_logfile.sh                                                     \
    $vasopipeline_logfiles_dir                                               \
    $(basename "$0" .sh)

suma_dir=$1
output_dir=$2
upsampled_anat=$3
subID=$4
linDepth=$5
hemisphere=$6

if [ ! -f "$upsampled_anat" ]; then
    echo ""
    echo "Upsampled anatomical does not exists"
    echo ""
    exit 1 
fi

cd $suma_dir

\mkdir -p $output_dir

echo ""
echo "++ Generate RIBBON volume mask"
echo ""

3dSurf2Vol                                                                   \
    -spec      std_BOTH.ld${linDepth}.${hemisphere}.spec                     \
    -surf_A    std_${hemisphere}.ld${linDepth}.${hemisphere}.smoothwm.gii    \
    -surf_B    std_${hemisphere}.ld${linDepth}.${hemisphere}.pial.gii        \
    -sv        T1.nii                                                        \
    -gridset   $upsampled_anat                                               \
    -map_func  mask                                                          \
    -f_steps   40                                                            \
    -f_index   points                                                        \
    -f_p1_fr   1.05                                                          \
    -f_pn_fr   0.1                                                           \
    -prefix    $output_dir/ribbonmask_${linDepth}_${hemisphere}_min_1p05_0p1.nii.gz \
    -overwrite

echo "Generate CSF volume mask"

3dSurf2Vol                                                                   \
    -spec      std_BOTH.ld${linDepth}.${hemisphere}.spec                     \
    -surf_A    std_${hemisphere}.ld${linDepth}.${hemisphere}.smoothwm.gii    \
    -surf_B    std_${hemisphere}.ld${linDepth}.${hemisphere}.pial.gii        \
    -sv        T1.nii                                                        \
    -gridset   $upsampled_anat                                               \
    -map_func  mask                                                          \
    -f_steps   40                                                            \
    -f_index   points                                                        \
    -f_p1_fr   0.90                                                          \
    -f_pn_fr   0.0                                                           \
    -prefix    $output_dir/supra6_pial_${linDepth}_${hemisphere}.nii.gz      \
    -overwrite

3dcalc                                                                       \
    -a       $output_dir/ribbonmask_${linDepth}_${hemisphere}_min_1p05_0p1.nii.gz \
    -b       $output_dir/supra6_pial_${linDepth}_${hemisphere}.nii.gz        \
    -expr    'a*b'                                                           \
    -prefix  $output_dir/supra7_pial_${linDepth}_${hemisphere}.nii.gz

# generate GM

echo "++ Generate GM volume mask"

# to test w/o applying any distance calculation #####
3dSurf2Vol                                                                   \
    -spec      std_BOTH.ld${linDepth}.${hemisphere}.spec                     \
    -surf_A    std_${hemisphere}.ld${linDepth}.${hemisphere}.smoothwm.gii    \
    -surf_B    std_${hemisphere}.ld${linDepth}.${hemisphere}.pial.gii        \
    -sv        T1.nii                                                        \
    -gridset   $upsampled_anat                                               \
    -map_func  mask                                                          \
    -f_steps   40                                                            \
    -f_index   points                                                        \
    -f_p1_fr   0.0                                                           \
    -f_pn_fr   0.0                                                           \
    -prefix    $output_dir/GM_${hemisphere}.nii.gz                           \
    -overwrite
#####################################################

echo "++ Generate WM volume mask"

# remove pial by subtracting 7 supra7_pial_${linDepth}_${hemisphere}
# to have GM without kissing gyri
# generate WM
3dSurf2Vol                                                                   \
    -spec      std_BOTH.ld${linDepth}.${hemisphere}.spec                     \
    -surf_A    std_${hemisphere}.ld${linDepth}.${hemisphere}.smoothwm.gii    \
    -surf_B    std_${hemisphere}.ld${linDepth}.${hemisphere}.pial.gii        \
    -sv        T1.nii                                                        \
    -gridset   $upsampled_anat                                               \
    -map_func  mask                                                          \
    -f_steps   40                                                            \
    -f_index   points                                                        \
    -f_p1_fr   -1.0                                                          \
    -f_pn_fr   0.0                                                           \
    -prefix    $output_dir/WM_${hemisphere}.nii.gz                           \
    -overwrite

# Go back to previous working directory
echo ""
echo "++ Going back to previous working directory"
cd -

