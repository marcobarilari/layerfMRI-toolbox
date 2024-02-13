# !bin/bash

set -e

## Prepare the freesurfer output for surface analyses
# this is used to get a better rim as input for layers
#
# usage: run_suma_fs_to_surface.sh <fspath> <subID>

print_process_logfile.sh \
    $vasopipeline_logfiles_dir \
    suma_fs_to_surface

fspath=$1
subID=$2  

@SUMA_Make_Spec_FS \
    -sid $subID \
    -fspath $fspath \
    -NIFTI 

    # -ldpref check if it take the suma output somewhere else