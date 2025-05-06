#!/bin/bash

# run as 
# docker run -v $(pwd)/example_script.sh:/docker_run.sh -it docker_lfrmi-toolbox bash /docker_run.sh
echo "Running fMRI tools inside Docker!"
afni --version
antsRegistration --version
octave --eval "disp('SPM12 is ready!')"

