function run_presurfer_denoise(UNIT1, INV2)

    % Run denoising using `presurfer` that is a git submodule
    % in `layerfMRI-toolbox/lib/presurfer`

    % initialize presurfer
    this_dir = fileparts(mfilename('fullpath'));
    addpath(fullfile(this_dir, '..', '..', 'lib', 'presurfer', 'func'));

    presurf_MPRAGEise(INV2,UNIT1);
    