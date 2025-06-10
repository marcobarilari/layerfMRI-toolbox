# !bin/bash

set -e

## Run freesurfer recon-all for high-res data
#
# usage: run_freesurfer_recon_all.sh <filename> <output_dir> <openmp>

# no need to print out the recon-all logfile since freesurfer takes care of it
# you can find it in <freesurfer-output>/scripts/recon-all.log

filename=$1
output_dir=$2
openmp=$3
anat_mask=$4

echo ""
echo "Will run recon-all on: "
echo " - $filename"

# remove the recon-all output otherwise freesurfer complains
\rm -rf $output_dir
\mkdir -p $output_dir

SUBJECTS_DIR=$output_dir

recon-all                                                                    \
    -all                                                                     \
    -s         $output_dir                                                   \
    -hires                                                                   \
    -i         $filename                                                     \
    -expert    "$(dirname $0)"/expert.opts                                   \
    -parallel                                                                \
    -openmp    $openmp                                                       \
    -xmask     $anat_mask

# echo ""
# echo "recon-all done!"
# echo "Find the output here : $output_dir"
# echo ""
