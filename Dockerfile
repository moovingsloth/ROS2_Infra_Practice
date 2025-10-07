FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Seoul

WORKDIR /workspace

RUN apt-get update && apt-get install -y \
    cmake \
    build-essential \
    libopencv-dev \
    libeigen3-dev \
    git \
    wget \
    && rm -rf /var/lib/apt/lists/*

COPY . /workspace/

RUN chmod +x build.sh

RUN sed -i '/sudo apt update/,/echo "System dependencies installed successfully!"/c\echo "Skipping system dependencies (already installed in Docker image)"' build.sh && \
    ./build.sh

# Set the entry point to a helper script
COPY docker_entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker_entrypoint.sh
ENTRYPOINT ["docker_entrypoint.sh"]

# Default command (can be overridden)
CMD ["--help"]