#!/bin/bash


root_yoda=/mnt/HD_jupiter/marcobarilari/github/layerfMRI-toolbox/demos/demo_toy_data
code=/mnt/HD_jupiter/marcobarilari/github/layerfMRI-toolbox
inputs=$root_yoda/inputs/raw
outputs=$root_yoda/outputs/derivatives
fs_licese=/usr/local/freesurfer/7.3.2

docker run -it --rm \
   -v $code:/opt/layerfMRI-toolbox \
   -v $inputs:data/inputs \
   -v $outputs:data/outputs \
   -v $fs_licese/license.txt:/license.txt:ro \
   -e FS_LICENSE='/license.txt' \
   layerfmri_toolbox \
   bash demo_temp.sh # run the pipeline script



