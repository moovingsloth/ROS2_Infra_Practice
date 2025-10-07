#!/bin/bash
set -e

# Parse arguments
DATASET_PATH=""
if [ -n "$1" ]; then
    DATASET_PATH=$1
fi

# Change to the build directory
cd /workspace/build

# Check if a dataset path is provided
if [ -z "$DATASET_PATH" ]; then
    echo "No dataset path provided. Running with --help."
    exec ./main_program --help
else
    echo "Dataset path provided: $DATASET_PATH"
    echo "Starting interactive shell..."
    exec /bin/bash
fi