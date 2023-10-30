ARG ROS_DISTRO=humble
ARG PREFIX=

FROM ros:$ROS_DISTRO-ros-base AS pkg-builder

# select bash as default shell
SHELL ["/bin/bash", "-c"]

WORKDIR /ros2_ws

# install everything needed
RUN git clone https://github.com/husarion/sllidar_ros2.git /ros2_ws/src/sllidar_ros2 -b update-s2 && \
    rosdep update --rosdistro $ROS_DISTRO && \
    rosdep install --from-paths src --ignore-src -y && \
    source /opt/ros/$ROS_DISTRO/setup.bash && \
    colcon build --symlink-install --event-handlers console_direct+

FROM husarnet/ros:${PREFIX}${ROS_DISTRO}-ros-core

ARG PREFIX
ENV PREFIX_ENV=$PREFIX

# select bash as default shell
SHELL ["/bin/bash", "-c"]

COPY --from=pkg-builder /ros2_ws /ros2_ws
COPY healthcheck.py /
COPY run_healthcheck.sh /

RUN echo $(cat /ros2_ws/src/sllidar_ros2/package.xml | grep '<version>' | sed -r 's/.*<version>([0-9]+.[0-9]+.[0-9]+)<\/version>/\1/g') > /version.txt

HEALTHCHECK --interval=10s --timeout=10s --start-period=5s --retries=6  \
    CMD /run_healthcheck.sh

# Without this line LIDAR doesn't stop spinning on container shutdown. Default is SIGTERM.
STOPSIGNAL SIGINT
