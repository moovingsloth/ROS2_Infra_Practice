FROM osrf/ros:humble-desktop-full AS builder

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Seoul

WORKDIR /ros2_ws


# Install required packages
RUN apt-get update && apt-get install -y \
      tree \
      cmake \
      build-essential \
      git \
      python3-pip \
      ros-humble-demo-nodes-cpp \
      ros-humble-demo-nodes-py && \
      pip install --no-cache-dir numpy onnxruntime torch && \
    rm -rf /var/lib/apt/lists/*

# Copy source files
COPY . .

# Resolve ROS2 dependencies conflict
RUN rosdep update
RUN rosdep install --from-paths src --ignore-src -y --rosdistro humble

RUN colcon build --symlink-install

COPY docker_entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker_entrypoint.sh
ENTRYPOINT ["docker_entrypoint.sh"]

# CMD ["ros2", "launch", "your_package_name", "your_launch_file.py"]




