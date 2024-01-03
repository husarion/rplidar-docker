<h1 align="center">
  Docker Images for RPlidar
</h1>

The repository includes a GitHub Actions workflow that automatically deploys built Docker images to the [husarion/rplidar-docker](https://hub.docker.com/r/husarion/rplidar) Docker Hub repositories. This process is based on a fork of the [fork of Slamtec/sllidar_ros2](https://github.com/Slamtec/sllidar_ros2)repository.

[![ROS Docker Image](https://github.com/husarion/rplidar-docker/actions/workflows/ros-docker-image.yaml/badge.svg)](https://github.com/husarion/rplidar-docker/actions/workflows//ros-docker-image.yaml)

## Prepare Environment

1. Plugin the Device

You can use `lsusb` command to check if the device is visible.

## Demo

1. Clone the Repository

   ```bash
   git clone https://github.com/husarion/rplidar-docker.git
   cd rplidar-docker/demo
   ```

2. Select the Appropriate Baudrate

   ```bash
   export RPLIDAR_BAUDRATE=<baudrate>
   ```

   Replace `<baudrate>` with appropriate baudrate for your LiDAR from below table.

   | **Product Name** | **Baudrate**  |
   | ---------------- | ------------- |
   | RPlidar A2M8     | **`115200`**  |
   | RPlidar A2M12    | **`256000`**  |
   | RPlidar A3       | **`256000`**  |
   | RPlidar S1       | **`256000`**  |
   | RPlidar S2       | **`1000000`** |
   | RPlidar S3       | **`1000000`** |

3. Activate the Device

   ```bash
   docker compose up rplidar
   ```

4. Launch Visualization

   ```bash
   xhost local:root
   docker compose up rviz
   ```

> [!NOTE]
> To use the latest version of the image, run the `docker compose pull` command.

## Parameters

The original launch has been modified with the new parameters:

| **Product Name**   | **Description**                                                                                                                             | **Default Value**      |
| ------------------ | ------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------- |
| `launch_file`      | Name of launch file from repo `sllidar_ros2` to run                                                                                         | `sllidar_launch.py`    |
| `serial_baudrate`  | Baudrate of connected lidar (depend on your RPlidar model)                                                                                  | `115200`               |
| `serial_port`      | USB port of connected lidar                                                                                                                 | `/dev/ttyUSB0`         |
| `robot_namespace`  | Namespace which will appear in front of all topics (including `/tf` and `/tf_static`).                                                      | `env("ROS_NAMESPACE")` (`""` if not specified) |
| `device_namespace` | Sensor namespace that will appear before all non absolute topics and TF frames, used for distinguishing multiple cameras on the same robot. | `""`                   |

Using both `device_namespace` and `robot_namespace` makes:

- Topic: `/<robot_namespace>/<device_namespace>/<default_topic>`
- Topic TF: `/<robot_namesace>/tf`
- URDF Links: `<device_namespace>_link`

If any of the namespaces are missing, the field with `/` is omitted for topics, or replaced with default ones for URDF links.
