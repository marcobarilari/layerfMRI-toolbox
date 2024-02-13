# !bin/bash

set -e

## Upsample the surface ouptut
#
# usage: upsample_SUMA_surface.sh <SUMA_dir> <upsampled_anat> <subID> <linDepth> <hemispher>

print_process_logfile.sh \
    $vasopipeline_logfiles_dir \
    run_surface_to_rim

SUMA_dir=$1
output_dir=$2
upsampled_anat=$3
subID=$4
linDepth=$5
hemisphere=$6

get dense mesh

MapIcosahedron \
    -spec ${subID}_${hemisphere}.spec \
    -ld $linDepth \
    -prefix std_${hemisphere}.ld$linDepth. \
    -overwrite \
    -verb

echo  "dense mesh starting"

# get spec for the new file
quickspec \
    -tn gii \
    std_${hemisphere}.ld${linDepth}.${hemisphere}.pial.gii

mv \
    quick.spec \
    std_${hemisphere}.ld${linDepth}.${hemisphere}.pial.spec

quickspec \
    -tn gii \
    std_${hemisphere}.ld${linDepth}.${hemisphere}.smoothwm.gii

mv \
    quick.spec \
    std_${hemisphere}.ld${linDepth}.${hemisphere}.smoothwm.spec

inspec \
    -LRmerge \
    std_${hemisphere}.ld${linDepth}.${hemisphere}.smoothwm.spec \
    std_${hemisphere}.ld${linDepth}.${hemisphere}.pial.spec \
    -detail 2 \
    -prefix std_BOTH.ld${linDepth}.${hemisphere}.spec \
    -overwrite