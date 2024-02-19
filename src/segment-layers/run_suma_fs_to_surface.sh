# !bin/bash

## Prepare the freesurfer output for surface analyses
# this is used to get a better rim as input for layers
#
# usage: run_suma_fs_to_surface.sh <fspath> <suma_output_dir> <subID>

set -e

print_process_logfile.sh \
    $(basename "$0" .sh)
    
fs_surf_path=$1
suma_output_dir=$2
subID=$3

# delete otherwise it will not rerun
rm -rf $fs_surf_path/SUMA

@SUMA_Make_Spec_FS \
    -sid $subID \
    -fspath $fs_surf_path \
    -NIFTI 

    # -ldpref check if it take the suma output somewhere else

rm -rf  $suma_output_dir

mkdir -p $suma_output_dir

mv $fs_surf_path/SUMA $suma_output_dir
