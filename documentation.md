# ✅ Summary of Tool Usage

| Preprocessing Step                               | FSL       | HCP Pipelines | ANTs     | dcm2niix | FreeSurfer | Implemented | Tool Used                |
|--------------------------------------------------|-----------|--------------|----------|----------|------------|-------------|--------------------------|
| **DICOM to NIfTI**                               | ❌        | ✅           | ❌       | ✅ (Best) | ❌         | ✅         | `dcm2niix`             |
| **Slice Timing Correction**                      | ✅        | ❌           | ❌       | ❌        | ❌         | ✅         | `slicetimer`            |
| **Motion Correction (MCFLIRT)**                  | ✅        | ✅           | ❌       | ❌        | ❌         | ✅         | `mcflirt`               |
| **Mean Image (Tmean)**                           | ✅        | ❌           | ❌       | ❌        | ❌         | ✅         | `fslmaths -Tmean`       |
| **Brain Extraction (BET)**                       | ✅        | ✅           | ❌       | ❌        | ❌         | ✅         | `bet`                   |
| **Create 4D Mask**                               | ✅        | ❌           | ❌       | ❌        | ❌         | ✅         | `fslmaths -bin`         |
| **Intensity Scaling (After BET)**                | ✅        | ❌           | ❌       | ❌        | ❌         | ✅         | `fslmaths -ing`         |
| **Coregistration (FLIRT)**                       | ✅        | ✅           | ❌       | ❌        | ❌         | ✅         | `flirt`                 |
| **Normalization (MNI, FNIRT)**                   | ✅        | ✅           | ✅       | ❌        | ❌         | ✅         | `fnirt`                 |
| **Parcellation**                                 | ❌        | ❌           | ❌       | ❌        | ✅         | ✅         | `Freesurfer`            |

---

## Updated Preprocessing Pipeline

| **Preprocessing Step**                                  | **FSL** | **HCP Pipelines** | **ANTs** | **dcm2niix** | **FreeSurfer** | **Implemented** | **Tool Used**          |
|---------------------------------------------------------|---------|-------------------|----------|--------------|---------------|----------------|------------------------|
| **DICOM to NIfTI**                                      | ❌      | ✅                 | ❌       | ✅ (Best)    | ❌            | ✅              | `dcm2niix`             |
| **Slice Timing Correction**                             | ✅      | ❌                 | ❌       | ❌          | ❌            | ✅              | `slicetimer`           |
| **Motion Correction (MCFLIRT)**                         | ✅      | ✅                 | ❌       | ❌          | ❌            | ✅              | `mcflirt`              |
| **Mean Image (Tmean)**                                  | ✅      | ❌                 | ❌       | ❌          | ❌            | ✅              | `fslmaths -Tmean`      |
| **Brain Extraction (BET)**                              | ✅      | ✅                 | ❌       | ❌          | ❌            | ✅              | `bet`                  |
| **Create 4D Mask**                                      | ✅      | ❌                 | ❌       | ❌          | ❌            | ✅              | `fslmaths -bin`        |
| **Intensity Scaling** *(after BET)*                     | ✅      | ❌                 | ❌       | ❌          | ❌            | ✅              | `fslmaths -ing`        |
| **Coregistration (FLIRT)**                              | ✅      | ✅                 | ❌       | ❌          | ❌            | ✅              | `flirt`                |
| **Normalization (MNI, FNIRT)**                          | ✅      | ✅                 | ✅       | ❌          | ❌            | ✅              | `fnirt`                |
| **Parcellation**                                        | ❌      | ❌                 | ❌       | ❌          | ✅            | ✅              | `Freesurfer`           |

---

### Notes
- The first step (`DICOM to NIfTI`) was performed using `dcm2niix`.
- Steps **2 to 9** were performed using **FSL**.
- The final step (**Parcellation**) was performed using **FreeSurfer**.
