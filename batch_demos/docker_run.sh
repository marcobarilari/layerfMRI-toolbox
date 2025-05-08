#!/bin/bash

# run as 
# docker run -it --rm \
#    -v /home/marcobarilari/github/layerfMRI-toolbox/license.txt:/license.txt:ro \
#    -e FS_LICENSE='/license.txt'
#    -v $(pwd)/batch_demos/docker_run.sh:/docker_run.sh \
#    layerfmri_toolbox \
#    bash /docker_run.sh

# CHECKS
# 3dSkullStrip
# LN2_LAYERS
# antsApplyTransforms
# freesurfer

echo "Running fMRI tools inside Docker!"
# afni --version
# antsRegistration --version
octave --eval "disp('SPM12 is ready!')"

