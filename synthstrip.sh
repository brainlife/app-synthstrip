#!/bin/bash

set -ex

# configurable inputs
dwi=`jq -r '.input' config.json`
input=nodif.nii.gz
input_type=dwi
bvals=`jq -r '.bvals' config.json`
bvecs=`jq -r '.bvecs' config.json`
border=`jq -r '.border' config.json`

# make output directories
outdir_t1=output_t1
[ ! -d ${outdir_t1} ] && mkdir -p ${outdir_t1}

outdir_mask=output_mask
[ ! -d ${outdir_mask} ] && mkdir -p ${outdir_mask}

# run synthstrip to get mask and brain extracted image
[ ! -f ${outdir_mask}/mask.nii.gz ] && mri_synthstrip -i ${input} -o tmp.nii.gz -m ${outdir_mask}/mask.nii.gz

# mask dwi volumes
[ ! -f ${outdir_t1}/${input_type}.nii.gz ] && mri_mask ${dwi} ${outdir_mask}/mask.nii.gz ${outdir_t1}/${input_type}.nii.gz

# final check
if [ -f ${outdir_mask}/mask.nii.gz ]; then
	echo "complete"
	cp ${bvals} ${outdir_t1}/${input_type}.bvals
	cp ${bvecs} ${outdir_t1}/${input_type}.bvecs
	rm -rf tmp.nii.gz nodif.nii.gz
	exit 0
else
	echo "something went wrong. check logs"
	exit 1
fi
