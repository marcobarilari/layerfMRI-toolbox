# !bin/bash

set -e

## Prepare the freesurfer output for surface analyses
# this is used to get a better rim as input for layers
#
# usage: run_suma_fs_to_surface.sh <fspath> <subID>

print_process_logfile.sh \
    suma_fs_to_surface

echo "exit for debugging"


fs_surf_path=$1
subID=$2  

@SUMA_Make_Spec_FS \
    -sid $subID \
    -fspath $fs_surf_path \
    -NIFTI 

mv $fs_surf_path/SUMA $suma_output_dir
    # -ldpref check if it take the suma output somewhere else