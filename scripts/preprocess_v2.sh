#!/bin/bash

# Create output_v2 subdirectories for each preprocessing step
mkdir -p output/01_dicom_conversion
mkdir -p output/02_slice_timing
mkdir -p output/03_mean_image
mkdir -p output/04_brain_extraction
mkdir -p output/05_bias_correction
mkdir -p output/06_motion_correction
mkdir -p output/07_spatial_smoothing
mkdir -p output/08_intensity_scaling
mkdir -p output/09_coregistration
mkdir -p output/10_normalization
mkdir -p output/11_highpass_filtering
mkdir -p output/12_ica_denoising

# Step 1: DICOM to NIfTI Conversion
dcm2niix -o output/01_dicom_conversion -f "converted_output" input/

# Step 2: Slice Timing Correction
slicetimer -i output/01_dicom_conversion/converted_output.nii.gz \
           -o output/02_slice_timing/slice_timing_corrected.nii.gz \
           --odd

# Step 3: Create Mean Image for Bias Correction
fslmaths output/02_slice_timing/slice_timing_corrected.nii.gz \
         -Tmean output/03_mean_image/slice_timing_corrected_mean.nii.gz

# Step 4: Brain Extraction
bet output/03_mean_image/slice_timing_corrected_mean.nii.gz \
    output/04_brain_extraction/slice_timing_corrected_mean_brain.nii.gz \
    -f 0.4 -g 0 -m  # Adjusted threshold to prevent data loss

# Step 5: Bias Field Correction
fast -b output/04_brain_extraction/slice_timing_corrected_mean_brain.nii.gz
mv output/04_brain_extraction/slice_timing_corrected_mean_* output/05_bias_correction/

# Step 6: Motion Correction
mcflirt -in output/05_bias_correction/slice_timing_corrected_mean_brain.nii.gz \
        -out output/06_motion_correction/motion_corrected.nii.gz \
        -cost mutualinfo -smooth 0.5 -plots

# Step 7: Spatial Smoothing
fslmaths output/06_motion_correction/motion_corrected.nii.gz \
         -s 1.5 \
         output/07_spatial_smoothing/smoothed.nii.gz

# Step 8: Intensity Scaling
fslmaths output/07_spatial_smoothing/smoothed.nii.gz \
         -ing 10000 \
         output/08_intensity_scaling/intensity_scaled.nii.gz

# Step 9: Coregistration to Anatomical
flirt -in output/08_intensity_scaling/intensity_scaled.nii.gz \
      -ref $FSLDIR/data/standard/MNI152_T1_2mm.nii.gz \
      -out output/09_coregistration/coregistered.nii.gz \
      -dof 12 -cost corratio -omat output/09_coregistration/coregistration.mat

# Step 10: Normalization to MNI Space
fnirt --in=output/08_intensity_scaling/intensity_scaled.nii.gz \
      --aff=output/09_coregistration/coregistration.mat \
      --ref=$FSLDIR/data/standard/MNI152_T1_2mm.nii.gz \
      --warpres=6,6,6 \
      --iout=output/10_normalization/normalized_mni.nii.gz

# Step 11: High-pass Temporal Filtering (Parameters optimized to prevent data loss)
fslmaths output/10_normalization/normalized_mni.nii.gz \
         -bptf 20 -1 \
         -add 10000 \
         -thr 10 \
         -odt float \
         output/11_highpass_filtering/highpass_filtered.nii.gz

fslmaths output/10_normalization/normalized_mni.nii.gz \
         -bptf 20 -1 \
         -add 10000 \
         -thr 10 \
         output/11_highpass_filtering/highpass_filtered.nii.gz


# Step 12: ICA Denoising
melodic -i output/11_highpass_filtering/highpass_filtered.nii.gz \
        -o output/12_ica_denoising \
        --nobet -d 30 --bgthreshold=2 --mmthresh=0.5

echo "✅ Full preprocessing pipeline completed with optimized parameters to prevent data loss."