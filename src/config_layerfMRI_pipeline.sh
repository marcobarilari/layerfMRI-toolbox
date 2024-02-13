# !bin/bash

set -e

## set up the environment here below

export FREESURFER_HOME=/Applications/freesurfer/7.4.1

source $FREESURFER_HOME/SetUpFreeSurfer.sh


## do not modify from here below 

# Add to path the scripts in subfolders
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PATH=$PATH$( find $SCRIPT_PATH/src/ -type d -printf ":%p" )

