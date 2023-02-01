#!/bin/bash

set -ex
dwi=`jq -r '.input' config.json`
bvals=`jq -r '.bvals' config.json`

[ ! -f ./nodif.nii.gz ] && select_dwi_vols ${dwi} ${bvals} ./nodif.nii.gz 0 -m
