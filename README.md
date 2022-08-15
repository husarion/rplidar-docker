# rplidar-docker

Dockerized rplidar_ros2 package from [fork of Slamtec/sllidar_ros2](https://github.com/Slamtec/sllidar_ros2) repository.

## Running a Docker container

```bash
docker run --rm -it \
    --device /dev/ttyUSB0 \
    husarion/rplidar:humble \
   ros2 launch sllidar_ros2 sllidar_launch.py 
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



