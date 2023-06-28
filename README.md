# rplidar-docker

Dockerized rplidar ROS 2 package from [fork of Slamtec/sllidar_ros2](https://github.com/Slamtec/sllidar_ros2) repository.

## Running a Docker container

```bash
# check /dev/ttyUSBX port for RPLIDAR
LIDAR_SERIAL=/dev/ttyUSB1

# for RPLIDAR A2M8 (red circle around the sensor):
# LIDAR_BAUDRATE=115200
# for RPLIDAR A2M12 and A3 (violet circle around the sensor):
LIDAR_BAUDRATE=256000

docker run --rm -d \
    --device ${LIDAR_SERIAL}:/dev/ttyUSB0 \
    husarion/rplidar:humble \
    ros2 launch sllidar_ros2 sllidar_launch.py serial_baudrate:=${LIDAR_BAUDRATE}
```

there is a new `/scan` topic available:

```bash
husarion@rosbotxl:~$ ros2 topic list
/parameter_events
/rosout
/scan
```

## ROS Node

### Publishes
- `/scan` *(sensor_msgs/LaserScan)*

## Demo

### RPLIDAR container + rviz container

Connect RPLIDAR to the first computer and run:

```bash
cd demo
docker compose -f compose.rplidar.yaml up
```

On the second computer (or the first one) with connected display run:

```bash
cd demo
xhost local:root
docker compose -f compose.rviz.yaml up
```

## Note

`humble` and `galactic` branches were replaced by `ros2` branch. Here's a quick cheat sheet how it was done:

```bash
# tag the branch
git tag archive/humble humble

# delete the branch locally
git branch -D humble

# delete the branch on GitHub
git push origin :humble

# push "archive/humble" tag on GitHub
git push --tags
```
