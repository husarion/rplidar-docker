ARG ROS_DISTRO=galactic

FROM ros:$ROS_DISTRO-ros-base AS pkg-builder

# select bash as default shell
SHELL ["/bin/bash", "-c"]

WORKDIR /ros2_ws

# install everything needed
RUN git clone https://github.com/husarion/sllidar_ros2.git /ros2_ws/src/sllidar_ros2 -b main && \
    rosdep update --rosdistro $ROS_DISTRO && \
    rosdep install --from-paths src --ignore-src -y && \
    source /opt/ros/$ROS_DISTRO/setup.bash && \
    colcon build --symlink-install --event-handlers console_direct+

FROM husarnet/ros:$ROS_DISTRO-ros-core

# select bash as default shell
SHELL ["/bin/bash", "-c"]

WORKDIR /ros2_ws

COPY --from=pkg-builder /ros2_ws /ros2_ws

RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> ~/.bashrc
RUN echo "source /ros2_ws/install/setup.bash" >> ~/.bashrc

# Without this line LIDAR doesn't stop spinning on container shutdown. Default is SIGTERM. 
STOPSIGNAL SIGINT