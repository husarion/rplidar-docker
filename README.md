<h1 align="center">
  Docker Images for RPlidar
</h1>

The repository includes a GitHub Actions workflow that automatically deploys built Docker images to the [husarion/rplidar-docker](https://hub.docker.com/r/husarion/rplidar) Docker Hub repositories. This process is based on a fork of the [fork of Slamtec/sllidar_ros2](https://github.com/Slamtec/sllidar_ros2)repository.

[![ROS Docker Image](https://github.com/husarion/rplidar-docker/actions/workflows/ros-docker-image.yaml/badge.svg)](https://github.com/husarion/rplidar-docker/actions/workflows//ros-docker-image.yaml)


## Prepare Environment

**1. Plugin the Device**

You can use `lsusb` command to check if the device is visible.

## Demo

**1. Clone the Repository**

```bash
git clone https://github.com/husarion/rplidar-docker.git
cd rplidar-docker/demo
```

**2. Specify Configuration**

```bash
# Select LIDAR baudrate:
# - 115200 - for RPLIDAR A2M8 (red circle around the sensor)
# - 256000 - for RPLIDAR A2M12 and A3 (violet circle around the sensor)
LIDAR_BAUDRATE=256000
```

**3. Activate the Device**

```bash
docker compose up rplidar
```

**4. Launch Visualization**

```bash
xhost local:root
docker compose up rviz
```

> [!NOTE]
> You can run the visualization on any device, provided that it is connected to the computer to which the sensor is connected.
