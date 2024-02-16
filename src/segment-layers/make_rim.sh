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

# LN2_LAYERS \
#     -rim rim4LN.nii.gz \
#     -nr_layers 7 \
#     -equivol \
#     -thickness \
#     -equal_counts \
#     -incl_borders