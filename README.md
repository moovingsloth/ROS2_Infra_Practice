# ROS2_Infra_Practice
This ROS2 CI/CD project is designed for learning core principles of Robotics, especially DevOps, MLOps, and RobOps. Automate regression test, with Euroc Dataset
It performs build, test, simulation, Docker deployment automatically, usign Isaac Sim(headless mode) with Euroc Dataset.

## Pipeline Structure

| Stage | Description |
|--------|-------------|
| **Build** | Build ROS2 workspace 'colcon build' |
| **Test** | Run test with 'rostest' and 'pytest' |
| **Simulation** | Validate regression test in headless Isaac Sim using EuRoC dataset|
| **Docker Deploy** | Build and push Docker image upon successful regression |


## Goal
1. End-to-End MLOps Pipeline
[ ] **Model and Dataset Agility:** Design pipeline for seamless **Model Under Test (MUT)** and **Dataset version** swapping.

2. Standardized RobOps Environment
[ ] ROS 2 Containerization

3. Operational Observability Loop
[ ] Real-Time Monitoring + Edge device 

[ ] Baseline Comparison


# To-Do list
[ ] 개발 문서 작성: 프로젝트 개요, 시스템 아키텍쳐, CI/CD 파이프라인

# Optional
[ ] tmpfs 사용해보고, 성능 비교
[ ] Jenkins or GitHub Actions: event 기반 자동화
[ ] on-premise에서 cloud 환경으로 확장(terraform)
[ ] TUM RGD-D, KITTI 데이터셋도 테스트

## References
- [ROS2 Deployment Guidelines](https://docs.ros.org/en/humble/Tutorials/Advanced/Security/Deployment-Guidelines.html#deployment-guidelines)
- [Docker Hub - ROS Official Images](https://hub.docker.com/_/ros)
- [Docker Build Best Practices](https://docs.docker.com/build/building/best-practices/)
