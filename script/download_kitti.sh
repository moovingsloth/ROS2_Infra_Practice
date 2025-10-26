#!/bin/bash

# KITTI Visual Odometry Dataset Downloader
# Reference: http://www.cvlibs.net/datasets/kitti/eval_odometry.php

# 1. Check for the destination directory argument.
if [ -z "$1" ]; then
  echo "Error: Please provide a destination directory."
  echo "Usage: $0 <path_to_destination_directory>"
  echo "Example: $0 ../dataset/kitti"
  exit 1
fi

DEST_DIR="$1"

# 2. Create the directory and navigate into it.
mkdir -p "$DEST_DIR"
echo "KITTI Visual Odometry dataset will be downloaded and extracted into: ${DEST_DIR}"
cd "$DEST_DIR"

# Base URL for KITTI datasets
BASE_URL="https://s3.eu-central-1.amazonaws.com/avg-kitti"

# KITTI Visual Odometry dataset files
DATASETS=(
    "data_odometry_gray.zip"           # Grayscale images (22 GB)
    "data_odometry_color.zip"          # Color images (65 GB) - Optional
    "data_odometry_poses.zip"          # Ground truth poses
    "data_odometry_calib.zip"          # Calibration files
)

# Function to convert bytes to human readable format
human_readable_size() {
    local bytes=$1
    local units=("B" "KB" "MB" "GB" "TB")
    local unit=0
    
    while [ $bytes -ge 1024 ] && [ $unit -lt 4 ]; do
        bytes=$((bytes / 1024))
        unit=$((unit + 1))
    done
    
    echo "${bytes}${units[$unit]}"
}

# Dataset size information (approximate)
declare -A DATASET_SIZES
DATASET_SIZES["data_odometry_gray.zip"]="22GB"
DATASET_SIZES["data_odometry_color.zip"]="65GB"
DATASET_SIZES["data_odometry_poses.zip"]="4MB"  
DATASET_SIZES["data_odometry_calib.zip"]="1MB"

echo "========================================="
echo "KITTI Visual Odometry Dataset Downloader"
echo "========================================="
echo ""
echo "Available datasets:"
echo "1. data_odometry_gray.zip    - Grayscale stereo images (~22GB)"
echo "2. data_odometry_color.zip   - Color stereo images (~65GB)"
echo "3. data_odometry_poses.zip   - Ground truth poses (~4MB)"
echo "4. data_odometry_calib.zip   - Camera calibration (~1MB)"
echo ""

# Ask user which datasets to download
echo "Which datasets would you like to download?"
echo "Enter numbers separated by spaces (e.g., '1 3 4' for gray images, poses, and calibration)"
echo "Or press Enter for essential datasets (1, 3, 4):"
read -r user_choice

# Default selection: grayscale images, poses, and calibration
if [ -z "$user_choice" ]; then
    selected_indices=(0 2 3)  # data_odometry_gray, poses, calib
    echo "Selected: Essential datasets (grayscale images, poses, calibration)"
else
    selected_indices=()
    for choice in $user_choice; do
        case $choice in
            1) selected_indices+=(0) ;;  # data_odometry_gray.zip
            2) selected_indices+=(1) ;;  # data_odometry_color.zip
            3) selected_indices+=(2) ;;  # data_odometry_poses.zip
            4) selected_indices+=(3) ;;  # data_odometry_calib.zip
            *) echo "Invalid choice: $choice (ignored)" ;;
        esac
    done
fi

echo ""
echo "Starting download..."
echo "==================="

for index in "${selected_indices[@]}"; do
    DATASET_FILE="${DATASETS[$index]}"
    DATASET_SIZE="${DATASET_SIZES[$DATASET_FILE]}"
    
    echo ""
    echo ">>>>> Processing ${DATASET_FILE} (Size: ${DATASET_SIZE})..."
    
    # Check if already downloaded and extracted
    case "$DATASET_FILE" in
        "data_odometry_gray.zip")
            if [ -d "sequences" ] && [ -d "sequences/00" ]; then
                echo ">>>>> Gray images already exist. Skipping."
                continue
            fi
            ;;
        "data_odometry_color.zip")
            if [ -d "sequences" ] && [ -f "sequences/00/image_02/data/000000.png" ]; then
                echo ">>>>> Color images already exist. Skipping."
                continue
            fi
            ;;
        "data_odometry_poses.zip")
            if [ -d "poses" ]; then
                echo ">>>>> Poses already exist. Skipping."
                continue
            fi
            ;;
        "data_odometry_calib.zip")
            if [ -f "sequences/00/calib.txt" ]; then
                echo ">>>>> Calibration files already exist. Skipping."
                continue
            fi
            ;;
    esac
    
    echo ">>>>> 1. Downloading ${DATASET_FILE}..."
    
    # Download with progress bar and resume capability
    wget -c --show-progress "${BASE_URL}/${DATASET_FILE}"
    
    if [ -f "${DATASET_FILE}" ]; then
        echo ">>>>> 2. Extracting ${DATASET_FILE}..."
        
        # Extract based on file type
        case "$DATASET_FILE" in
            *.zip)
                unzip -q "${DATASET_FILE}"
                if [ $? -eq 0 ]; then
                    echo ">>>>> 3. Successfully extracted ${DATASET_FILE}"
                    echo ">>>>> 4. Deleting zip file: ${DATASET_FILE}"
                    rm "${DATASET_FILE}"
                else
                    echo ">>>>> Error: Failed to extract ${DATASET_FILE}"
                    continue
                fi
                ;;
        esac
        
        echo ">>>>> Finished processing ${DATASET_FILE}!"
    else
        echo ">>>>> Error: Failed to download ${DATASET_FILE}"
    fi
done

echo ""
echo "========================================="
echo "Download Summary"
echo "========================================="

# Verify downloaded content
if [ -d "sequences" ]; then
    num_sequences=$(find sequences -maxdepth 1 -type d -name "[0-9][0-9]" | wc -l)
    echo "✓ Image sequences: $num_sequences sequences found"
    
    # List available sequences
    if [ $num_sequences -gt 0 ]; then
        echo "  Available sequences:"
        for seq_dir in sequences/[0-9][0-9]; do
            if [ -d "$seq_dir" ]; then
                seq_num=$(basename "$seq_dir")
                left_images=$(find "$seq_dir/image_00/data" -name "*.png" 2>/dev/null | wc -l)
                right_images=$(find "$seq_dir/image_01/data" -name "*.png" 2>/dev/null | wc -l)
                echo "    - Sequence $seq_num: $left_images left + $right_images right images"
            fi
        done
    fi
else
    echo "✗ No image sequences found"
fi

if [ -d "poses" ]; then
    num_poses=$(find poses -name "*.txt" | wc -l)
    echo "✓ Ground truth poses: $num_poses pose files found"
else
    echo "✗ No pose files found"
fi

# Check calibration
calib_files=$(find sequences -name "calib.txt" 2>/dev/null | wc -l)
if [ $calib_files -gt 0 ]; then
    echo "✓ Calibration files: $calib_files calibration files found"
else
    echo "✗ No calibration files found"
fi

echo ""
echo "========================================="
echo "Usage Information"
echo "========================================="
echo "To test with KITTI dataset:"
echo "  ./build/test_kitti ${DEST_DIR}/sequences/00"
echo "  ./build/test_unified ${DEST_DIR}/sequences/00"
echo ""
echo "Dataset structure:"
echo "  sequences/"
echo "    ├── 00/...10/          # Training sequences"
echo "    └── 11/...21/          # Test sequences"
echo "  poses/"
echo "    ├── 00.txt...10.txt    # Ground truth poses for training"
echo ""
echo "All tasks have been completed successfully!"
echo "Total size on disk: $(du -sh . 2>/dev/null | cut -f1)"