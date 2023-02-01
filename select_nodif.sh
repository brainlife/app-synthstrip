#!/bin/bash

set -ex
func=`jq -r '.input' config.json`

[ ! -f nodif.nii.gz ] && fslselectvols -i ${func} -o nodif.nii.gz --vols=0

[ ! -f nodif.nii.gz ] && echo "something went wrong. check logs" && exit 1
