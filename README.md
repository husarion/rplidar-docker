# rplidar-docker
Dockerized rplidar_ros package from https://github.com/Slamtec/rplidar_ros repository.

This repository contains a workflow for auto-deployment of built image to https://hub.docker.com/r/husarion/rplidar repository.

## Examples

### RPLIDAR container + rviz container

```bash
cd examples/rviz
docker-compose up --build
```