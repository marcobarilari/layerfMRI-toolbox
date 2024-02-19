# layerfMRI-toolbox v0.1.0 - BETA*

(*) new commits will break the code very often

This is a bash/python/matlab/R toolbox to perfomr layer-fMRI VASO analyses using many softwares. Mostly a set of wrapper functions tailored for layer-fMRI analyses from start to bottom, there are examples on how to put things together but feel free to plug here and there your custom code for your custom analyses tailored to your specific project/data.

## How to use it

The layerfMRI-toolbox helps woth two main strams of data analyses:

1. segmentatio and layerification of anatomical data.
2. vaso timeseries preprocessing.

### Prerequisite

* AFNI vXXX (in the path)
* LAYNII vXXX (in the path)
* Freesurfer vXXX
* SPM12 vXXX (in the path)
* ANTS vXXX
* Presurfer commit: (as submodule)
* Nordic commit:
* A good computer (better if it is a crunch computer or a cluster)
* Basic experience with Python/Bash scripting
* Lots of patient :) (tips: most of the time is just a path problem)

Tested on Linux (Ubuntu xxx) and Mac OSX xxx

### Installation

1. Add this repo to your analysis project folder (see below for suggestions) via git operation.

```bash
git clone -recursive https://github.com/marcobarilari/layerfMRI-toolbox.git
```

2. Check you have all the prerequisites listed in this README file.

3. Check the config file `config_layerfMRI_pipeline.sh` and modify it according to your software paths.

4. Check the demos for suggested pipelines in the `batch demos` (and check paths there as well if you intend to use them).

You should be good to go

### What it can do [WIP]

* Prepapre (`presurfer`) and segment (`freesurfer`) and anatomical using e.g. `MP2RAGE`

* Prepare a high quality rim file (WM GM pial mask) for layeryfication (`SUMA`) (manual editig might be needed though)

* Coregister the rim file to EPI distorde space (`ANTs`)

* Create layers mask (`LAYNII`)

* Apply thermal noisecleaning on VASO data (`NORDIC`)
  
* Preprocess VASO data (motion correction `AFNI`; bold correction `LAYNII`, T1w image from `nulled` contrast)

* Quality metrics (`LAYNII`) as tSNR, noise distribution etc.

* For almost each process, it spits out a logfile `process_name_YYYYMMDDHHMMSS.txt` which is what is printed in the comand line. Useful for debuggin and when multiple processeses are running on the background in remote machines within seprate sessions (e.g. using `screen`).

### Data input format

1. Nifti files, what else
2. It deals with
   1. `(nulled + not nulled).nii` series 
   2. `nulled.nii` and `not nulled.nii` separated series
   3. time series with nordic noise volumes appended at the end

## Ideal project folder structure, this is a yoda folder:

```bash
`analyses_layerfMRI_your-project-name`
    .
    ├── code
    │   ├── lib # where layerfMRI-toolbox lives
    │   ├── src # where your code and the the batch file to run layerfMRI-toolbox live
    ├── inputs
    │   └── raw # your awesome raw dataset + other input to not touch, ideally bidslike format
    └── outputs
        └── derivates # where any processed file will be saved in seprate subfolders named by `software-step` 
```

## Ideal structure of the derivatives (see demos):

see [WIP-folder_organization](WIP-folder_organization.md) and provide feedbacks. Thinking about t options atm.

## Phylosophy of the pipeline

1. Everyone is welcome to contribute.
2. We don't believe this is the only way to analyze layer fMRI (VASO) data. It is one way of many, we just want to make it easier and faster.
3. If you have a differnet and cool way to tackle a particular step, please make it available for everyone adding it to this repo. 
4. This pipeline is a transparent box. We keep it easy so that eveyrone can easily open the scripts and look what is happening inside and contribute.
5. Each called "function" has an input and an output and should do just one operation/step on the data.
6. The pipeline is made of modules that can be ordered in a differnet way. The example demo is just an example that suits the dummy data. In your paradigm you may have slightly different things that may benefit from eg a different steps order or custom code. Just get inspired.

## TO DO: looking for contributions

- Python/jupiter notebook based batch
- Improvements in the current method
- Add alternative methods
- Add better documentation + educational material
- Write tests