IMAGE_NAME="ros2_infra_practice"
TAG="latest"
echo "Building Docker image: ${IMAGE_NAME}:${TAG}"
sudo docker build -t "${IMAGE_NAME}:${TAG}" .
if [ $? -eq 0 ]; then
    echo "Docker image built successfully!"
    echo "Image name: $IMAGE_NAME:$TAG"
else
    echo "Failed to build Docker image"
    exit 1
fi