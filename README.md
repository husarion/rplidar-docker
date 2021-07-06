# rplidar-docker
Dockerized rplidar_ros package from https://github.com/Slamtec/rplidar_ros repository.

This repository contains a GitHub Actions workflow for auto-deployment of built Docker image to https://hub.docker.com/r/husarion/rplidar repository.

## Examples

### RPLIDAR container + rviz container

Connect RPLidar to your laptop and deppending you have NVIDIA GPU or not, choose the right example:

#### [option 1] NVIDIA GPU

```bash
cd examples/rviz/nvidia

xhost local:root
docker-compose up --build
```

#### [option 2] Intel GPU

```bash
cd examples/rviz/intel

xhost local:root
docker-compose up --build
```