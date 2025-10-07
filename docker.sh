IMAGE_NAME="ros2_infra_practice"
TAG="latest"
echo "Building Docker image: ${IMAGE_NAME}:${TAG}"
docker build -t "${IMAGE_NAME}:${TAG}" .
