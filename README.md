<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

**Brain-extracts an fMRI time series by running FreeSurfer 7.3.2 SynthStrip on its first volume and applying the brain mask to the whole series, and outputs the masked BOLD and the mask.**

Extracts the first volume of the BOLD series with FSL fslselectvols, computes a brain mask from it with mri_synthstrip, and applies the mask to every volume with mri_mask. Use it when you need a skull-stripped functional run or a functional-space brain mask. Needs a task fMRI image; the mask is defined on the first volume, so large head motion across the run is not accounted for.

Run it on brainlife.io: [https://doi.org/10.25663/brainlife.app.726](https://doi.org/10.25663/brainlife.app.726)

| Input | Datatype | Required | Description |
|---|---|---|---|
| `input` | `neuro/func/task` | yes | Task fMRI 4D BOLD image (with its events and optional sbref and physio files). |

| Output | Datatype | Description |
|---|---|---|
| `output_t1` | `neuro/func/task` | The input BOLD series with non-brain voxels zeroed. |
| `output_mask` | `neuro/mask` | Binary brain mask (mask.nii.gz) in functional space. |

| Parameter | Type | Default | Description |
|---|---|---|---|
| `border` | number | `1` | mask border threshold in mm |

Runtime: container `brainlife/fsl:6.0.4`; 4 CPUs; 20 GB memory; 0.5 h walltime; needs `FREESURFER_LICENSE`.

<!-- brainlife-app:end -->

# app-synthstrip