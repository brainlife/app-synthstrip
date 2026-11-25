<h1 align="center">SynthStrip brain extraction</h1>

<p align="center">
  Brain-extracted images and binary brain masks for T1-weighted, T2-weighted, FLAIR, diffusion and functional MRI, with FreeSurfer SynthStrip.
</p>

<p align="center">
  <a href="https://github.com/brainlife/abcd-spec"><img src="https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg" alt="ABCD Spec v1.1"></a>
  <a href="https://doi.org/10.25663/brainlife.app.726"><img src="https://img.shields.io/badge/Brainlife-brainlife.app.726-blue.svg" alt="Run on brainlife.io"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-lightgrey.svg" alt="MIT license"></a>
</p>

## At a glance

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

> **Brain-extracts an fMRI time series by running FreeSurfer 7.3.2 SynthStrip on its first volume and applying the brain mask to the whole series, and outputs the masked BOLD and the mask.**

Extracts the first volume of the BOLD series with FSL fslselectvols, computes a brain mask from it with mri_synthstrip, and applies the mask to every volume with mri_mask. Use it when you need a skull-stripped functional run or a functional-space brain mask. Needs a task fMRI image; the mask is defined on the first volume, so large head motion across the run is not accounted for.

| | |
|---|---|
| **Inputs** | `neuro/func/task` |
| **Outputs** | `neuro/func/task` · `neuro/mask` |
| **Container** | `brainlife/fsl:6.0.4` |
| **Resources** | 4 CPUs · 20 GB memory · 0.5 h walltime |
| **Requires** | `FREESURFER_LICENSE` |
| **Run it** | [doi.org/10.25663/brainlife.app.726](https://doi.org/10.25663/brainlife.app.726) |

#### Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `input` | `neuro/func/task` | yes | Task fMRI 4D BOLD image (with its events and optional sbref and physio files). |

#### Outputs

| Output | Datatype | Description |
|---|---|---|
| `output_t1` | `neuro/func/task` | The input BOLD series with non-brain voxels zeroed. |
| `output_mask` | `neuro/mask` | Binary brain mask (mask.nii.gz) in functional space. |

<details>
<summary><b>Parameters</b> (1)</summary>

| Parameter | Type | Default | Description |
|---|---|---|---|
| `border` | number | `1` | mask border threshold in mm |

</details>

<!-- brainlife-app:end -->

## Versions on brainlife.io

One App per input datatype, built from a branch of this repository.

| App | Input | Branch | Run it | Status |
|---|---|---|---|---|
| Generate brain extracted image with SynthStrip (FMRI) | `neuro/func/task` | [`func-7.3.2`](https://github.com/brainlife/app-synthstrip/tree/func-7.3.2) | [doi:10.25663/brainlife.app.726](https://doi.org/10.25663/brainlife.app.726) | current |
| Generate brain extracted image with SynthStrip (DWI) | `neuro/dwi` | [`dwi-7.3.2`](https://github.com/brainlife/app-synthstrip/tree/dwi-7.3.2) | [doi:10.25663/brainlife.app.725](https://doi.org/10.25663/brainlife.app.725) | current |
| Generate brain extracted image with SynthStrip (FLAIR) | `neuro/anat/flair` | [`7.3.2`](https://github.com/brainlife/app-synthstrip/tree/7.3.2) | [doi:10.25663/brainlife.app.724](https://doi.org/10.25663/brainlife.app.724) | current |
| Generate brain extracted image with SynthStrip (T2w) | `neuro/anat/t2w` | [`7.3.2`](https://github.com/brainlife/app-synthstrip/tree/7.3.2) | [doi:10.25663/brainlife.app.723](https://doi.org/10.25663/brainlife.app.723) | current |
| Generate brain extracted image with SynthStrip (T1w) | `neuro/anat/t1w` | [`7.3.2`](https://github.com/brainlife/app-synthstrip/tree/7.3.2) | [doi:10.25663/brainlife.app.722](https://doi.org/10.25663/brainlife.app.722) | current |

## Running the App

### On brainlife.io

Open the App for your datatype from the table above, choose the image from your project and press **Execute**. The App runs `mri_synthstrip` from FreeSurfer 7.3.2, a deep-learning brain extraction tool that works across contrasts and resolutions. Each App outputs the brain-extracted image, with the same datatype as the input and tagged `brain_extracted`, and a binary brain mask (`neuro/mask`) in the input image space.

- **T1w, T2w and FLAIR**: `mri_synthstrip` is run on the image itself.
- **DWI**: the b=0 volumes are averaged with FSL `select_dwi_vols`, the mask is computed from that mean b0 image and applied to every volume with `mri_mask`; bvals and bvecs are carried over. The DWI must include b=0 volumes.
- **fMRI**: the mask is computed from the first volume of the BOLD series (FSL `fslselectvols`) and applied to every volume with `mri_mask`. Large head motion across the run is not accounted for.

### Locally

You need [Singularity/Apptainer](https://apptainer.org/), [`jq`](https://jqlang.github.io/jq/) and a [FreeSurfer license](https://surfer.nmr.mgh.harvard.edu/registration.html). FreeSurfer 7.3.2 (and FSL for DWI and fMRI) run inside containers.

1. Clone this repository and check out the branch of the App you want (`7.3.2` for T1w/T2w/FLAIR, `dwi-7.3.2` or `func-7.3.2`).
2. Create `config.json` with the path to your image. For T1w/T2w/FLAIR, `input_type` (`t1`, `t2` or `flair`) names the output file:

   ```json
   {
       "input": "/input/t1/t1.nii.gz",
       "input_type": "t1",
       "border": 1
   }
   ```

   For DWI, also give `"bvecs"` and `"bvals"`.

3. Export your license and run the App:

   ```bash
   export FREESURFER_LICENSE="$(cat ~/freesurfer/license.txt)"
   ./main
   ```

The `border` option (mask border threshold in mm) is read from `config.json` but is not currently passed to `mri_synthstrip`.

## Outputs

```text
output_t1/
└── <input_type>.nii.gz   brain-extracted image (dwi.nii.gz with .bvals and .bvecs for DWI, bold.nii.gz for fMRI)
output_mask/
└── mask.nii.gz           binary brain mask in the input image space
```

## Troubleshooting

- **`Please set FREESURFER_LICENSE in .bashrc`**: export the contents of your FreeSurfer `license.txt` as `FREESURFER_LICENSE` before running `./main`.
- **`something went wrong. check logs`**: the brain-extracted image or mask was not produced. Check the job log for the `mri_synthstrip` error.

## Citing

> [!TIP]
> If you use this App in your work, please cite the App, the software it builds on and brainlife.io (below). GitHub's **Cite this repository** button gives the App citation in APA and BibTeX.

- Generate brain extracted image with SynthStrip (FMRI). brainlife.io App. [doi:10.25663/brainlife.app.726](https://doi.org/10.25663/brainlife.app.726)
- Fischl. FreeSurfer. *NeuroImage* 62:774-781 (2012). [doi:10.1016/j.neuroimage.2012.01.021](https://doi.org/10.1016/j.neuroimage.2012.01.021)
- Jenkinson et al. FSL. *NeuroImage* 62:782-790 (2012). [doi:10.1016/j.neuroimage.2011.09.015](https://doi.org/10.1016/j.neuroimage.2011.09.015)
- Hoopes et al. SynthStrip: skull-stripping for any brain image. *NeuroImage* 260:119474 (2022). [doi:10.1016/j.neuroimage.2022.119474](https://doi.org/10.1016/j.neuroimage.2022.119474)
- Hayashi S, Caron BA, Heinsfeld AS, et al. brainlife.io: a decentralized and open-source cloud platform to support neuroscience research. *Nature Methods* 21:809–813 (2024). [doi:10.1038/s41592-024-02237-2](https://doi.org/10.1038/s41592-024-02237-2)
- Avesani P, McPherson B, Hayashi S, et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. *Scientific Data* 6:69 (2019). [doi:10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)

## Authors

- Brad Caron

## Funding

[![Wellcome-226486/Z/22/Z](https://img.shields.io/badge/Wellcome-226486%2FZ%2F22%2FZ-purple.svg)](https://wellcome.org/)
[![NIH-NINDS-U24NS140384](https://img.shields.io/badge/NIH_NINDS-U24NS140384-green.svg)](https://reporter.nih.gov/project-details/11261037)
[![NIH-NINDS-UM1NS132207](https://img.shields.io/badge/NIH_NINDS-UM1NS132207-green.svg)](https://reporter.nih.gov/project-details/11411328)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://reporter.nih.gov/project-details/10262925)
[![NIH-NIBIB-R01EB030896](https://img.shields.io/badge/NIH_NIBIB-R01EB030896-green.svg)](https://reporter.nih.gov/project-details/10428625)
[![NIH-NIMH-R01MH126699](https://img.shields.io/badge/NIH_NIMH-R01MH126699-green.svg)](https://reporter.nih.gov/project-details/10460628)
[![NIH-NIDCD-R01DC020088](https://img.shields.io/badge/NIH_NIDCD-R01DC020088-green.svg)](https://reporter.nih.gov/project-details/11140284)
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-2203524](https://img.shields.io/badge/NSF_BCS-2203524-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2203524)
[![NSF-IIS-1636893](https://img.shields.io/badge/NSF_IIS-1636893-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-OAC-2148729](https://img.shields.io/badge/NSF_OAC-2148729-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148729)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NSF-IIS-2148700](https://img.shields.io/badge/NSF_IIS-2148700-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148700)
[![NSF-OAC-1916518](https://img.shields.io/badge/NSF_OAC-1916518-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1916518)

<sub>brainlife.io is publicly funded, and acknowledging that support helps keep it running. This App was developed with support from Wellcome, the U.S. National Institutes of Health (including the BRAIN Initiative BRAIN CONNECTS program: The Axonal Projectome EXchange, U24NS140384, and the Center for Mesoscale Connectomics, UM1NS132207) and the U.S. National Science Foundation.</sub>

## License

[MIT](LICENSE). FreeSurfer itself is distributed under its own [license](https://surfer.nmr.mgh.harvard.edu/fswiki/FreeSurferSoftwareLicense).
