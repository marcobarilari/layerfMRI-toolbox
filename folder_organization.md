## YODA folder

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

## Derivatives option 1

```bash
└── derivatives
    ├── layerfMRI-logfiles
    │   ├── sub-01
    │   └── sub-02
    └── layerfMRI-segmentation-layer
    │   ├── sub-01
    │   │   ├── SUMA
    │   │   ├── freesurfer
    │   │   └── rim-layers
    │   └── sub-02
    │       ├[...]
    └── layerfMRI-preprocessing
        ├── sub-01
        │   ├── moco
        │   ├── boco
        │   ├── figures
        │   ├── nordic-boco
        │   ├── nordic-boco
        │   ├── sub-01_qm_report_nordic.html
        │   └── sub-01_qm_report_nordic.html
        └── sub-02
            ├[...]
```

## Derivatives option 2

```bash
└── derivatives
    ├── layerfMRI-logfiles
    │   ├── sub-01
    │   └── sub-02
    └── layerfMRI-segmentation
    │   ├── sub-01
    │   │   ├── freesurfer
    │   │   └── presurf_MPRAGEise
    │   └── sub-02
    │       ├[...]
    └── layerfMRI-surface-mesh
    │   ├── sub-01
    │   │   └──  SUMA
    │   └── sub-02
    │       ├[...]
    └── layerfMRI-rim-layers
    │   ├── sub-01
    │   │   └──  roi
    │   └── sub-02
    │       ├[...]
    └── layerfMRI-preprocessing
        ├── sub-01
        │   ├── moco
        │   ├── boco
        │   ├── figures
        │   ├── nordic-boco
        │   ├── nordic-boco
        │   ├── sub-01_qm_report_nordic.html
        │   └── sub-01_qm_report_nordic.html
        └── sub-02
            ├[...]
```