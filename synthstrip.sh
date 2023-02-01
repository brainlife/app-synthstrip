#!/bin/bash

set -ex

# configurable inputs
input=`jq -r '.input' config.json`
border=`jq -r '.border' config.json`

# make output directories
outdir_t1=output_t1
[ ! -d ${outdir_t1} ] && mkdir -p ${outdir_t1}

outdir_mask=output_mask
[ ! -d ${outdir_mask} ] && mkdir -p ${outdir_mask}

# run synthstrip to get mask and brain extracted image
[ ! -f ${outdir_t1}/t1.nii.gz ] && mri_synthstrip -i ${input} -o ${outdir_t1}/t1.nii.gz -m ${outdir_mask}/mask.nii.gz

# final check
if [ -f ${outdir_mask}/mask.nii.gz ]; then
	echo "complete"
	exit 0
else
	echo "something went wrong. check logs"
	exit 1
fi
