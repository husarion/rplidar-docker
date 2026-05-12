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

2. Pick the channel + parameters for your model

   The wrapper invokes `sllidar_node` directly with the parameters you set.
   Pick `channel_type` and the channel-specific args based on your hardware:

   | **Model**           | **`channel_type`** | **Other settings**                                              |
   | ------------------- | ------------------ | --------------------------------------------------------------- |
   | A1, A2M8            | `serial`           | `serial_baudrate=115200`, `scan_mode=Sensitivity`               |
   | A2M7, A2M12, A3     | `serial`           | `serial_baudrate=256000`, `scan_mode=Sensitivity`               |
   | C1                  | `serial`           | `serial_baudrate=460800`, `scan_mode=Standard`                  |
   | S1                  | `serial`           | `serial_baudrate=256000`                                        |
   | S1 (TCP)            | `tcp`              | `tcp_ip=192.168.0.7`, `tcp_port=20108`                          |
   | S2, S3              | `serial`           | `serial_baudrate=1000000`, `scan_mode=DenseBoost`               |
   | S2E, T1             | `udp`              | `udp_ip=192.168.11.2`, `udp_port=8089`, `scan_mode=Sensitivity` |

   For serial models, export the baudrate via the env var used by `compose.yaml`:

   ```bash
   export RPLIDAR_BAUDRATE=<baudrate>
   ```

   For IP-based models (T1, S2E, S1_TCP) — uncomment the matching service in
   `compose.yaml` and remove the default `rplidar` service.

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

Inside the image there is a custom `/husarion_utils/rplidar.launch.yaml` that is not part of the upstream `sllidar_ros2` package. It was added for easy integration with Husarion robots. It accepts the following parameters:

| **Parameter**      | **Description**                                                                                                                             | **Default Value**      |
| ------------------ | ------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------- |
| `channel_type`     | Communication channel: `serial`, `udp` or `tcp`                                                                                             | `serial`               |
| `serial_baudrate`  | Baudrate (serial channel only)                                                                                                              | `256000`               |
| `serial_port`      | USB port (serial channel only)                                                                                                              | `/dev/ttyUSB0`         |
| `udp_ip`           | UDP IP of the lidar (udp channel only)                                                                                                      | `192.168.11.2`         |
| `udp_port`         | UDP port (udp channel only)                                                                                                                 | `8089`                 |
| `tcp_ip`           | TCP IP of the lidar (tcp channel only)                                                                                                      | `192.168.0.7`          |
| `tcp_port`         | TCP port (tcp channel only)                                                                                                                 | `20108`                |
| `inverted`         | Invert scan data                                                                                                                            | `false`                |
| `angle_compensate` | Enable angle compensation                                                                                                                   | `true`                 |
| `scan_mode`        | Lidar scan mode (`DenseBoost`, `Sensitivity`, `Standard`) — depends on model                                                                | `""`                   |
| `namespace`        | ROS namespace prefixing all topics                                                                                                          | `env("ROBOT_NAMESPACE")` (`""` if not specified) |
| `name`             | Prefix for the laser `frame_id` (becomes `<name>_link`); distinguishes multiple lidars on the same robot. If empty, `frame_id=laser`.       | `""`                   |

Using both `name` and `namespace` makes:

- Topic: `/<namespace>/<default_topic>`
- URDF Link / `frame_id`: `<name>_link` (default: `laser`)

If `namespace` is empty, the topic stays `/<default_topic>`. If `name` is empty, `frame_id` defaults to `laser`.
