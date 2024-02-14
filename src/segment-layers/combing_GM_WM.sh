### combine them

# combing_GM_WM.sh

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