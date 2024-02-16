# !bin/bash

## Prepare the freesurfer output for surface analyses
# this is used to get a better rim as input for layers
#
# usage: run_suma_fs_to_surface.sh <fspath> <suma_output_dir> <subID>

set -e

print_process_logfile.sh \
    suma_fs_to_surface

fs_surf_path=$1
suma_output_dir=$2
subID=$3

@SUMA_Make_Spec_FS \
    -sid $subID \
    -fspath $fs_surf_path \
    -NIFTI 

    # -ldpref check if it take the suma output somewhere else

mkdir -p $suma_output_dir

mv $fs_surf_path/SUMA $suma_output_dir
