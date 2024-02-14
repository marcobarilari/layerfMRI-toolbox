# !bin/bash

set -e

## set up the environment here below

export FREESURFER_HOME=/usr/local/freesurfer/7.3.2

source $FREESURFER_HOME/SetUpFreeSurfer.sh


## do not modify from here below 

# get the path of the current script aka the toolbox
SCRIPT_LAYERFMRI_TOOLBOX="$(dirname $0)"

# make all the scripts executable
chmod 777 $SCRIPT_LAYERFMRI_TOOLBOX/*/*.sh

# add the toolbox to the path
export PATH=$PATH:$(find $SCRIPT_LAYERFMRI_TOOLBOX -maxdepth 1 -type d | paste -sd ":" -)


