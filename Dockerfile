FROM ros:galactic-ros-base AS package_builder

# select bash as default shell
SHELL ["/bin/bash", "-c"]

WORKDIR /ros2_ws

# install everything needed
RUN apt-get update && apt-get install -y \
        ros-$ROS_DISTRO-rmw-fastrtps-cpp && \
    apt-get upgrade -y && \
    git clone https://github.com/Slamtec/rplidar_ros.git --branch=ros2 /ros2_ws/src/rplidar_ros && \
    source /opt/ros/$ROS_DISTRO/setup.bash && \
    colcon build --symlink-install

FROM husarion/ros:galactic-ros-core

# select bash as default shell
SHELL ["/bin/bash", "-c"]

COPY --from=package_builder /ros2_ws /ros2_ws

ENV RMW_IMPLEMENTATION=rmw_fastrtps_cpp

COPY ros_entrypoint.sh /