# !bin/bash

set -e

## Upsample the surface ouptut
#
# usage: upsample_SUMA_surface.sh <SUMA_dir> <upsampled_anat> <subID> <linDepth> <hemispher>

print_process_logfile.sh \
    $vasopipeline_logfiles_dir \
    run_surface_to_rim

SUMA_dir=$1
upsampled_anat=$2
subID=$3
linDepth=$4
hemisphere=$5

get dense mesh

MapIcosahedron \
    -spec ${subID}_${hemisphere}.spec \
    -ld $linDepth \
    -prefix std_${hemisphere}.ld$linDepth. \
    -overwrite \
    -verb

echo  "dense mesh starting"

# get spec for the new file
quickspec \
    -tn gii \
    std_${hemisphere}.ld${linDepth}.${hemisphere}.pial.gii

mv \
    quick.spec \
    std_${hemisphere}.ld${linDepth}.${hemisphere}.pial.spec

quickspec \
    -tn gii \
    std_${hemisphere}.ld${linDepth}.${hemisphere}.smoothwm.gii

mv \
    quick.spec \
    std_${hemisphere}.ld${linDepth}.${hemisphere}.smoothwm.spec

inspec \
    -LRmerge \
    std_${hemisphere}.ld${linDepth}.${hemisphere}.smoothwm.spec \
    std_${hemisphere}.ld${linDepth}.${hemisphere}.pial.spec \
    -detail 2 \
    -prefix std_BOTH.ld${linDepth}.${hemisphere}.spec \
    -overwrite

###### from S06

# https://github.com/kenshukoiso/Whole_Brain_Project/blob/main/script/s06_thinner_pial.sh

### left hemi

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
    -prefix ${output_dir}/GM_${hemisphere}.nii 
    
    # \
    # -overwrite
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


### right hemi ###

echo  " **************************"
echo  " RIGHT HEMISPHERE"
echo  " **************************"

echo "working on supra_pial"

3dSurf2Vol \
    -spec std_BOTH.ld${linDepth}.rh.spec \
    -surf_A std_rh.ld${linDepth}.rh.smoothwm.gii \
    -surf_B std_rh.ld${linDepth}.rh.pial.gii \
    -sv T1.nii \
    -gridset scaled_T1.nii.gz \
    -map_func mask \
    -f_steps 40 \
    -f_index points \
    -f_p1_fr 1.05 \
    -f_pn_fr 0.1 \
    -prefix ${output_dir}/supra_pial_${linDepth}_rh_min_1p05_0p1.nii \
    -overwrite

echo "working on supra6_pial"

3dSurf2Vol \
    -spec std_BOTH.ld${linDepth}.rh.spec \
    -surf_A std_rh.ld${linDepth}.rh.smoothwm.gii \
    -surf_B std_rh.ld${linDepth}.rh.pial.gii \
    -sv T1.nii \
    -gridset scaled_T1.nii.gz \
    -map_func mask \
    -f_steps 40 \
    -f_index points \
    -f_p1_fr 0.90 \
    -f_pn_fr 0.0 \
    -prefix ${output_dir}/supra6_pial_${linDepth}_rh.nii \
    -overwrite

echo "working on supra7_pial"

3dcalc \
    -a ${output_dir}/supra_pial_${linDepth}_rh_min_1p05_0p1.nii \
    -b ${output_dir}/supra6_pial_${linDepth}_rh.nii \
    -expr 'a*b' \
    -prefix ${output_dir}/supra7_pial_${linDepth}_rh.nii

echo "working on GM"

# to test w/o applying any distance calculation #####
3dSurf2Vol \
    -spec std_BOTH.ld${linDepth}.rh.spec \
    -surf_A std_rh.ld${linDepth}.rh.smoothwm.gii \
    -surf_B std_rh.ld${linDepth}.rh.pial.gii \
    -sv T1.nii \
    -gridset scaled_T1.nii.gz \
    -map_func mask \
    -f_steps 40 \
    -f_index points \
    -f_p1_fr 0.0 \
    -f_pn_fr 0.0 \
    -prefix ${output_dir}/GM_rh.nii \
    -overwrite
#####################################################

echo "working on WM"

3dSurf2Vol \
    -spec std_BOTH.ld${linDepth}.rh.spec \
    -surf_A std_rh.ld${linDepth}.rh.smoothwm.gii \
    -surf_B std_rh.ld${linDepth}.rh.pial.gii \
    -sv T1.nii \
    -gridset scaled_T1.nii.gz \
    -map_func mask \
    -f_steps 40 \
    -f_index points \
    -f_p1_fr -1.0 \
    -f_pn_fr 0.0 \
    -prefix ${output_dir}/WM_rh.nii \
    -overwrite

### combine them

echo "combining...."

3dcalc \
    -a ${output_dir}/GM_rh.nii \
    -b ${output_dir}/GM_lh.nii \
    -expr 'a + b ' \
    -prefix ${output_dir}/GM_vol.nii \
    -overwrite

3dcalc \
    -a ${output_dir}/supra7_pial_${linDepth}_rh.nii \
    -b ${output_dir}/supra7_pial_${linDepth}_lh.nii \
    -expr 'a + b ' \
    -prefix ${output_dir}/pial_vol.nii \
    -overwrite

3dcalc \
    -a ${output_dir}/WM_rh.nii \
    -b ${output_dir}/WM_lh.nii \
    -expr 'a + b' \
    -prefix ${output_dir}/WM_vol.nii \
    -overwrite

3dcalc \
    -a ${output_dir}/WM_vol.nii \
    -b ${output_dir}/GM_vol.nii \
    -c ${output_dir}/pial_vol.nii \
    -prefix ${output_dir}/rim012.nii \
    -overwrite \
    -expr 'step(a)*2-step(b)-step(c)'

##### then S07 https://github.com/kenshukoiso/Whole_Brain_Project/blob/main/script/s07_MC2Layering.sh


## get rim and layers

#rim012 -> rim4LN
3dcalc -a smooth_rim012.nii.gz -expr 'equals(a,1)' -prefix rimGM.nii.gz -overwrite
LN2_CHOLMO -layers rimGM.nii.gz -inner -nr_layers 1 -layer_thickness 0.44
3dcalc -a smooth_rim012.nii.gz -b rimGM_padded.nii.gz -expr 'equals(a,0)*equals(b,1)' -prefix rim_pia.nii.gz -overwrite -datum short
3dcalc -a smooth_rim012.nii.gz -b rimGM_padded.nii.gz -expr 'equals(a,2)*equals(b,1)' -prefix rim_WM.nii.gz -overwrite -datum short
3dcalc -a smooth_rim012.nii.gz -b rim_pia.nii.gz -c rim_WM.nii.gz  -expr 'equals(a,1)*3+b+c*2' -prefix rim4LN.nii.gz -overwrite -datum short


#apply layersinfication
# LN2_LAYERS -rim rim4LN.nii.gz -nr_layers 7 -equal_bins -incl_borders

LN2_LAYERS \
    -rim rim4LN.nii.gz \
    -nr_layers 7 \
    -equivol \
    -thickness \
    -equal_counts \
    -incl_borders

mv rim4LN_layerbins_equidist.nii.gz layers.nii.gz