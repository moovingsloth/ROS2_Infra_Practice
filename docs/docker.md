## Docker Installation (Recommended)

Using Docker is the recommended method as it provides a self-contained, consistent environment across different systems.

### Prerequisites

- **Docker** installed on your system
- **X11 forwarding** support (for visualization)

### Build the Docker Image

```bash
chmod +x docker.sh
./docker.sh build
```

This command builds a Docker image named `lightweight-vio:latest` with all necessary dependencies and source code.

### Step 4: Verify Docker Build

Check that the image was created successfully:

```bash
docker images | grep lightweight-vio
```