function run_presurfer_biasfieldcorr(imag_to_correct)

    % Run SPM12 biasfield correction using `presurfer` that is a git submodule
    % in `layerfMRI-toolbox/lib/presurfer`

    % initialize presurfer
    this_dir = fileparts(mfilename('fullpath'));
    addpath(fullfile(this_dir, '..', '..', 'lib', 'presurfer', 'func'));

    presurf_biascorrect(imag_to_correct)

    