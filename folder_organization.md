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

## Segmentation and layer pipeline

```bash
[...]
└── derivatives
    ├── layerfMRI-logfiles
    │   ├── sub-01
    │   └── sub-02
    └── layerfMRI-segmentation
        ├── sub-01
        │   ├── SUMA
        │   ├── freesurfer-reconall
        │   ├── layers
        │   └── rim
        └── sub-02
            ├── SUMA
            ├── freesurfer-reconall
            ├── layers
            └── rim
```