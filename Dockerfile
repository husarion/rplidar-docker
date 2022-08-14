
ARG ROS_DISTRO=galactic

# FROM ros:humble-ros-base
FROM ros:$ROS_DISTRO-ros-base

# select bash as default shell
SHELL ["/bin/bash", "-c"]

RUN apt update && apt install -y \
        ros-$ROS_DISTRO-rmw-fastrtps-cpp \
        ros-$ROS_DISTRO-rmw-cyclonedds-cpp && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /ros2_ws

# install everything needed
RUN git clone https://github.com/DominikN/sllidar_ros2.git /ros2_ws/src/sllidar_ros2 -b main && \
    rosdep update --rosdistro $ROS_DISTRO && \
    rosdep install --from-paths src --ignore-src -y && \
    source /opt/ros/$ROS_DISTRO/setup.bash && \
    colcon build --symlink-install --event-handlers console_direct+

COPY ros_entrypoint.sh /