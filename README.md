# rplidar-docker
Dockerized rplidar_ros package from [Slamtec/rplidar_ros](https://github.com/Slamtec/rplidar_ros) repository.

## Running a Docker container

```bash
docker run --rm -it \
    --device /dev/ttyUSB0 \
    husarion/rplidar:latest \
    roslaunch husarion_rplidar rplidar_a3.launch
```

## Examples

### RPLIDAR container + rviz container

Connect RPLidar to your laptop and depending you have NVIDIA GPU or not, choose the right example:

#### NVIDIA GPU

```bash
cd examples/rviz/nvidia

xhost local:root
docker-compose up
```

#### Intel GPU

```bash
cd examples/rviz/intel

xhost local:root
docker-compose up
```
