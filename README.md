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

2. Configure `demo/.env` for your model

   `compose.yaml` defines three rplidar services — `rplidar-serial`,
   `rplidar-tcp`, `rplidar-udp` — gated by Compose profiles. Pick the profile
   matching your hardware via `COMPOSE_PROFILES` in `demo/.env` and uncomment
   the matching parameter block:

   | **Model**           | **`COMPOSE_PROFILES`** | **Other settings**                                     |
   | ------------------- | ---------------------- | ------------------------------------------------------ |
   | A1, A2M8            | `serial`               | `RPLIDAR_BAUDRATE=115200`                              |
   | A2M7, A2M12, A3     | `serial`               | `RPLIDAR_BAUDRATE=256000`                              |
   | C1                  | `serial`               | `RPLIDAR_BAUDRATE=460800`                              |
   | S1                  | `serial`               | `RPLIDAR_BAUDRATE=256000`                              |
   | S1 (TCP)            | `tcp`                  | `RPLIDAR_TCP_IP=192.168.0.7`, `RPLIDAR_TCP_PORT=20108` |
   | S2, S3              | `serial`               | `RPLIDAR_BAUDRATE=1000000`                             |
   | S2E, T1             | `udp`                  | `RPLIDAR_UDP_IP=192.168.11.2`, `RPLIDAR_UDP_PORT=8089` |

   Each profile requires its own variables — starting a service without them
   aborts with a message pointing you to `demo/.env`.

3. Activate the Device and Visualization

   ```bash
   xhost local:root
   docker compose up
   ```

   Only the rplidar service for the active profile starts, alongside `rviz`.

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
| `name`             | Node name; distinguishes multiple lidars on the same robot.                                                                                 | `sllidar_node`         |
| `frame_id`         | TF `frame_id` of the laser scan.                                                                                                            | `laser`                |

Using `namespace`, `name` and `frame_id` together:

- Topic: `/<namespace>/<default_topic>`
- Node name: `<name>`
- TF frame: `<frame_id>`

If `namespace` is empty, topics stay at `/<default_topic>`.
