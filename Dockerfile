# FROM ros:humble-ros-base
FROM ros:humble-ros-base

# select bash as default shell
SHELL ["/bin/bash", "-c"]

WORKDIR /ros2_ws

# install everything needed
RUN git clone https://github.com/babakhani/rplidar_ros2 /ros2_ws/src/rplidar_ros -b ros2 && \
    rosdep update --rosdistro $ROS_DISTRO && \
    rosdep install --from-paths src --ignore-src -y && \
    source /opt/ros/$ROS_DISTRO/setup.bash && \
    colcon build --symlink-install --event-handlers console_direct+

COPY ros_entrypoint.sh /