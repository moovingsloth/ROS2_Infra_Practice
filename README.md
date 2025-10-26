# ROS2_Infra_Practice
This ROS2 CI/CD project is designed for learning core principles of Robotics, especially DevOps, MLOps, and RobOps. It implements a Visual-Inertial Odometry (VIO) system with automated regression testing using EuRoC and KITTI datasets, featuring Docker containerization and Isaac Sim integration for production-ready deployment. 

## Pipeline Structure

| Stage | Description | Example |
|--------|-------------|---------|
| **Build** | Build VIO system with CMake and ROS2 colcon | `colcon build`, `cmake ..` |
| **Test** | Run regression tests with multiple datasets | `./test_euroc ../dataset/euroc/MH_01_easy/` |
| **Simulation** | Validate in headless Isaac Sim environment | Automated VIO accuracy validation |
| **Docker Deploy** | Build and push optimized container images | Multi-stage Docker builds |

## Supported Datasets

### EuRoC MAV Dataset
- **Sequences**: 11 sequences (MH_01-05, V1_01-03, V2_01-03)  
- **Features**: Stereo images, IMU data, ground truth poses
- **Download**: `./script/download_euroc.sh dataset/euroc`
- **Usage**: `./build/test_euroc dataset/euroc/MH_01_easy/`

### KITTI Visual Odometry Dataset  
- **Sequences**: 22 sequences (00-21), 11 with ground truth poses
- **Features**: Stereo grayscale images, calibration data, GPS/IMU
- **Size**: 22GB (grayscale), 65GB (color)
- **Download**: `./script/download_kitti.sh dataset/kitti` 
- **Usage**: `./build/test_kitti dataset/kitti/dataset/sequences/00/`

## Goal
1. End-to-End MLOps Pipeline
[ ] **Model and Dataset Agility**: Design pipeline for seamless Model Under Test (MUT) and dataset version swapping
[ ] **Automated Benchmarking**: Performance comparison across EuRoC, KITTI, and TUM datasets

2. Standardized RobOps Environment  
[ ] **ROS2 Containerization**: Complete Docker integration with multi-stage builds
[ ] **Edge Deployment**: Jetson Nano optimization for production deployment
[ ] **Microservices Architecture**: Scalable SLAM system design

3. Operational Observability Loop
[ ] **Real-Time Monitoring**: System health and performance metrics on edge devices
[ ] **Regression Testing**: Automated accuracy validation with Isaac Sim integration

4. Quality Assurance
[ ] **Baseline Comparison**: Performance trend analysis and benchmarking dashboard


## Quick Start

### Prerequisites
```bash
sudo apt update
sudo apt install build-essential cmake git wget
sudo apt install libopencv-dev libeigen3-dev
```

### Build and Test
```bash
# Clone and build
git clone https://github.com/moovingsloth/ROS2_Infra_Practice.git
cd ROS2_Infra_Practice
mkdir build && cd build
cmake .. && make -j$(nproc)

# Download datasets  
../script/download_euroc.sh ../dataset/euroc
../script/download_kitti.sh ../dataset/kitti

# Run tests
./test_euroc ../dataset/euroc/MH_01_easy/
./test_kitti ../dataset/kitti/dataset/sequences/00/
```

### Docker Deployment
```bash
sudo docker build -t vio-system:latest .
sudo docker run -it --gpus all vio-system:latest
```

# To-Do list
[ ] 개발 문서 작성: 프로젝트 개요, 시스템 아키텍쳐, CI/CD 파이프라인
[ ] Isaac Sim 헤드리스 모드 통합: 자동화된 시뮬레이션 테스트 환경 구축
[ ] Jetson Nano 배포 최적화: 엣지 디바이스용 경량화 및 성능 튜닝
[ ] TUM RGB-D 데이터셋 지원 추가

# Optional Enhancements
[ ] tmpfs 사용 성능 비교: 메모리 기반 파일 시스템으로 I/O 최적화
[ ] Jenkins or GitHub Actions: 이벤트 기반 자동화 파이프라인 구축  
[ ] On-premise to Cloud 확장: Terraform을 활용한 클라우드 인프라 관리

## References
- [EuRoC MAV Dataset](https://projects.asl.ethz.ch/datasets/doku.php?id=kmavvisualinertialdatasets)
- [KITTI Visual Odometry Dataset](http://www.cvlibs.net/datasets/kitti/eval_odometry.php)
- [ROS2 Deployment Guidelines](https://docs.ros.org/en/humble/Tutorials/Advanced/Security/Deployment-Guidelines.html#deployment-guidelines)
- [Docker Hub - ROS Official Images](https://hub.docker.com/_/ros)
- [Docker Build Best Practices](https://docs.docker.com/build/building/best-practices/)
- [Isaac Sim Documentation](https://docs.omniverse.nvidia.com/isaacsim/latest/index.html) 
