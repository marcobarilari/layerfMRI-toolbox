# !bin/bash

set -e

yoda_name=$1
yoda_dir=$2

if [ -z "$yoda_dir" ]; then
    yoda_dir='.'
fi

if [ -d "$yoda_dir/$yoda_name" ]; then

    echo ""
    echo " *** A folder with the same name exists, be changed the folder name must. Hmm."

    exit 1

fi

# Create a directory for the YODA file
mkdir -p $yoda_dir/$yoda_name

mkdir -p $yoda_dir/$yoda_name/code/lib
mkdir -p $yoda_dir/$yoda_name/code/src

mkdir -p $yoda_dir/$yoda_name/inputs/raw
mkdir -p $yoda_dir/$yoda_name/outputs/derivatives

# clone the layerfMRI-toolbox
git clone --recursive https://github.com/marcobarilari/layerfMRI-toolbox.git $yoda_dir/$yoda_name/code/lib/layerfMRI-toolbox

echo ""
echo " *** ready to use the YODA $yoda_name folder is"
