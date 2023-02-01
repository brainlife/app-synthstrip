#!/bin/bash

set -ex
func=`jq -r '.input' config.json`

[ ! -f ./nodif.nii.gz ] && fslselectvols -i ${func} -o ./nodif.nii.gz --vols=0
