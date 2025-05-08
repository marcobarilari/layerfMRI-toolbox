```
    _____________________________________________________________
                                      _    _   _    ____       __
        /                           /      /  /|    /    )     / 
    ---/----__----------__---)__--_/__----/| /-|---/___ /-----/--
      /   /   ) /   / /___) /   ) /      / |/  |  /    |     /    
    _/___(___(_(___/_(___ _/_____/______/__/___|_/_____|__ _/_ __
                  /                                              
    __________(_ /_______________________________________________
```


# layerfMRI-toolbox v0.1.0 - BETA*

(*) new commits will break the code very often

This is a bash/python/matlab/R toolbox to perform layer-fMRI VASO analyses using many software. Mostly a set of wrapper functions tailored for layer-fMRI analyses from start to bottom, there are examples of how to put things together but feel free to plug here and there your custom code for your custom analyses tailored to your specific project/data.

## Contributors

- Marco Barilari
- Kenshu Koiso
- Paul A. Taylor
- Omer Faruk Gulban Taylor
- Daniel Glen
- Peter Bandettini
- Olivier Collignon
- Renzo Huber
- et al. ... if you think your name is missing, please do not hesitate to reach out

## TOC
- [layerfMRI-toolbox v0.1.0 - BETA\*](#layerfmri-toolbox-v010---beta)
  - [Contributors](#contributors)
  - [TOC](#toc)
  - [How to use it](#how-to-use-it)
    - [Prerequisite](#prerequisite)
    - [Installation](#installation)
      - [Automatic by creating the ideal project folder structure (aka a YODA folder):](#automatic-by-creating-the-ideal-project-folder-structure-aka-a-yoda-folder)
      - [Automatic by cloning a template with ideal project folder structure (aka a YODA folder) and DATALAD:](#automatic-by-cloning-a-template-with-ideal-project-folder-structure-aka-a-yoda-folder-and-datalad)
      - [Manual](#manual)
    - [Usage](#usage)
      - [Via docker image](#via-docker-image)
        - [Notes](#notes)
    - [What it can do \[WIP\]](#what-it-can-do-wip)
    - [Demo/Pipeline benchmarking](#demopipeline-benchmarking)
      - [From high-res anatomical to whole brain layers](#from-high-res-anatomical-to-whole-brain-layers)
    - [Data input format](#data-input-format)
  - [Ideal structure of the derivatives (see demos):](#ideal-structure-of-the-derivatives-see-demos)
  - [Philosophy of the pipeline](#philosophy-of-the-pipeline)
  - [TO DO: looking for contributions](#to-do-looking-for-contributions)

## How to use it

The layerfMRI-toolbox helps with two main streams of data analyses:

1. segmentation and layerification of anatomical data.
2. vaso time series preprocessing. [WIP - available in the future]

### Prerequisite

- AFNI vXXX (in the path)
- LAYNII vXXX (in the path)
- Freesurfer v7+ 
- Matlab with SPM12 vXXX (in the path)
- ANTS vXXX
- Presurfer commit: (as submodule)
- Nordic commit:
- A good computer (better if it is a crunch computer or a cluster)
- Basic experience with Python/Bash scripting
- Lots of patience :) (tips: most of the time is just a path problem)

Tested on Linux (Ubuntu xxx) and Mac OSX xxx

### Installation

#### Automatic by creating the ideal project folder structure (aka a YODA folder):

Download [this script](https://github.com/marcobarilari/layerfMRI-toolbox/blob/main/src/utils/make_yoda_layerfMRI-toolbox.sh) and run it as follow (change project folder name and directory where you want to create it):

```bash
bash path/to/make_yoda_layerfMRI-toolbox.sh \
  my_folder_project_name \
  where/I/want/to/create/it
```

```bash
# output structure

`analyses_layerfMRI_your-project-name`
    .
    ├── code
    │   ├── lib # where layerfMRI-toolbox lives
    │   ├── src # where your code and the batch file to run layerfMRI-toolbox live
    ├── inputs
    │   └── raw # your awesome raw dataset + other input to not touch, ideally bidslike format
    └── outputs
        └── derivates # where any processed file will be saved in separate subfolders named by `software-step` 
```

#### Automatic by cloning a template with ideal project folder structure (aka a YODA folder) and DATALAD:

Use the GitHub template [template_layerfMRI-toolbox_yoda](https://github.com/marcobarilari/template_layerfMRI-toolbox_yoda), it has already this toolbox installed

1. Got to the link (up-right)
2. Click on `Use this template` green button (up-right)
3. Set your name
4. Clone on your computer your new project repository via

```bash
# --recursive flag is very important!
git clone --recursive your/repo/url
```

5. Populate the repo with data a custom code

#### Manual

1. Add this repo to your analysis project folder (see below for suggestions) via git operation.

```bash
git clone --recursive https://github.com/marcobarilari/layerfMRI-toolbox.git
```

2. Check you have all the prerequisites listed in this README file.
3. Check the config file `config_layerfMRI_pipeline.sh` and modify it according to your software paths.
4. Check the demos for suggested pipelines in the `batch demos` (and check paths there as well if you intend to use them).

### Usage 

#### Via docker image

```bash
root_yoda=
code=$root_yoda/code/lib/layerfMRI_toolbox
inputs=$root_yoda/inputs
output=$root_yoda/outputs
fs_licese=path/to/freesurfe/license/fodler

docker run -it --rm \
  -v $code:/opt/layerfMRI-toolbox
  -v $inputs:inputs \
  -v $outputs:outputs \
  -v $fs_licese/license.txt:/license.txt:ro \
  -e FS_LICENSE='/license.txt' \
  
```
##### Notes

- If you encounter performance issues, consider increasing the resources allocated to Docker (e.g., memory, CPUs).
- The `FS_LICENSE` environment variable is required for Freesurfer. Make sure to replace `fs_licese` with the path to your Freesurfer license file.

This setup ensures a reproducible environment for running the `layerfMRI-toolbox` workflows.

### What it can do [WIP]

* Prepare (`presurfer`) and segment (`freesurfer`) and anatomical using e.g. `MP2RAGE`

* Prepare a high-quality rim file (WM GM pial mask) for layeryfication (`SUMA`) (manual editig might be needed though)

* Coregister the rim file to EPI distorde space (`ANTs`)

* Create layers mask (`LAYNII`)

* Apply thermal noise-cleaning on VASO data (`NORDIC`)
  
* Preprocess VASO data (motion correction `AFNI`; bold correction `LAYNII`, T1w image from `nulled` contrast)

* Quality metrics (`LAYNII`) as tSNR, noise distribution etc.

* For almost every process, it spits out a logfile `YYYYMMDDHHMMSS_process_name.txt` which is what is printed in the command line. Useful for debugging and when multiple processes are running in the background in remote machines within separate sessions (e.g. using `screen`).

### Demo/Pipeline benchmarking

The demo has been run on a crunching computer (cpp-labMONSTER):

- Linux 6.2.0-36-generic #37~22.04.1-Ubuntu
- 24 CPUs (Intel(R) Xeon(R) Gold 5118 CPU @ 2.30GHz)
- 64GB ram + 200GB swap memory

RAM and CPU usage are sampled every ~30 seconds.

#### From high-res anatomical to whole brain layers

This section refers to the demo `layerfMRI_pipeline_segment-layers.sh` using a high-res anatomical MP2RAGE whole brain (0.75 mm iso) and T1w in EPI space derived from vaso functional data of a specific task experiment (0.75 mm iso, partial brain coverage).

![image info](./src/benchmark/ram.png)

![image info](./src/benchmark/cpu.png)

![image info](./src/benchmark/disk.png)

CONCLUSION: It will hit hard on the memory (RAM or swap). To increase swap memory in Linux check here xxx. Windows and Mac should be already configured to ~~steal memory to the HD~~ increase the swap automatically if the RAM is full.

### Data input format

1. Nifti files, what else
2. It deals with
   1. `(nulled + not nulled).nii` series 
   2. `nulled.nii` and `not nulled.nii` separated series
   3. time series with nordic noise volumes appended at the end

## Ideal structure of the derivatives (see demos):

see [WIP-folder_organization](WIP-folder_organization.md) and provide feedbacks. Thinking about multiple options atm.

## Philosophy of the pipeline

1. Everyone is welcome to contribute.
2. We don't believe this is the only way to analyze layer fMRI (VASO) data. It is one way of many, we just want to make it easier and faster.
3. If you have a different and cool way to tackle a particular step, please make it available for everyone adding it to this repo. 
4. This pipeline is a transparent box. We keep it easy so that everyone can easily open the scripts and look at what is happening inside and contribute.
5. Each called "function" has an input and an output and should do just one operation/step on the data.
6. The pipeline is made of modules that can be ordered in a different way. The example demo is just an example that suits the dummy data. In your paradigm, you may have slightly different things that may benefit from eg a different steps order or custom code. Just get inspired.

## TO DO: looking for contributions

- Python/jupiter notebook based batch
- Improvements in the current method
- Add alternative methods
- Add better documentation + educational material
- Write tests
