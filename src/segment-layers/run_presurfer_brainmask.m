function run_presurfer_brainmask(INV2)

    % Run denoising using `presurfer` that is a git submodule
    % in `layerfMRI-toolbox/lib/presurfer`

    % initialize presurfer
    this_dir = fileparts(mfilename('fullpath'));
    addpath(fullfile(this_dir, '..', '..', 'lib', 'presurfer', 'func'));

    presurf_INV2(INV2);
    