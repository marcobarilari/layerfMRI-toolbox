# VASO pipeline v0.1.0 - BETA

This is a bash/python/matlab/R toolbox to perfomr layer-fMRI VASO analyses using many softwares.

## Ideal project folder structure

```bash
.
├── code
│   ├── lib # where VASOpipeline lives
│   ├── src # where your code and the the batch file to run VASOpipeline live
├── inputs
│   └── raw # your awesome raw dataset + other input to not touch, ideally bidslike format
└── outputs
    └── derivates # where any processed file will be saved in seprate subfolders named by `software-step` 
```

## Data input format

1. Nifti files, what else
2. It deals with 
   1. `(nulled + not nulled).nii` series 
   2. `nulled.nii` and `not nulled.nii` separated series
   3. time series with nordic noise volumes appended at the end

## Prerequisite

- AFNI vXXX (in the path)
- LAYNII vXXX (in the path)
- Freesurfer vXXX
- SPM12 vXXX (in the path)
- ANTS vXXX
- Presurfer commit: (as submodule)
- Nordic commit:
- A good computer (better if it is a crunch computer or a cluster)
- Basic experience with Python/Bash scripting
- Lots of patient :) (tips: most of the time is just a path problem)

Tested on Linux (Ubuntu xxx) and Mac OSX xxx

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