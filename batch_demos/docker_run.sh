#!/bin/bash

# run as 
# docker run \
#    -v $(pwd)/batch_demos/docker_run.sh:/docker_run.sh \
#    -it layerfmri_toolbox_v0.1.0 \
#    bash /docker_run.sh

echo "Running fMRI tools inside Docker!"
# afni --version
# antsRegistration --version
octave --eval "disp('SPM12 is ready!')"

