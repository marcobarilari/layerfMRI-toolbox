function run_presurfer_brainmask(UNIT1)

    % Run denoising using `presurfer` that is a git submodule
    % in `layerfMRI-toolbox/lib/presurfer`

    % initialize presurfer
    this_dir = fileparts(mfilename('fullpath'));
    addpath(fullfile(this_dir, '..', '..', 'lib', 'presurfer', 'func'));

    presurf_UNI(UNIT1);
    