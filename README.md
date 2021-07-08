# rplidar-docker
Dockerized rplidar_ros package from https://github.com/Slamtec/rplidar_ros repository.

This repository contains a GitHub Actions workflow for auto-deployment of built Docker image to https://hub.docker.com/r/husarion/rplidar repository.

## Building a Docker image

```bash
sudo docker build -t rplidar .
```

## Running a Docker image

```bash
xhost local:root

sudo docker run --rm -it \
--device /dev/ttyUSB0 \
rplidar \
roslaunch rplidar_ros rplidar.launch
```

## Examples (using Docker Compose)

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