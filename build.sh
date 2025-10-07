echo "Build Script Started"

NPROC=$(($(nproc) / 2))
if [ $NPROC -lt 1 ]; then
    NPROC=1
fi

# Install system dependencies
echo ""
echo "Installing system dependencies..."
sudo apt update
sudo apt install -y \
    cmake \
    build-essential

echo "System dependencies installed successfully!"

# Build main project
echo "Building the main project..."
# Create build directory for main project
if [ ! -d "build" ]; then
    mkdir build
fi

cd build

# Configure and build main project
cmake ..
make -j$NPROC