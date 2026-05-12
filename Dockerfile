# Define build stage for creating ROS packages
ARG ROS_DISTRO=humble
ARG PREFIX=

# =========================== package builder ===============================
FROM husarnet/ros:$ROS_DISTRO-ros-base AS pkg-builder

WORKDIR /ros2_ws

# Setup workspace
RUN git clone https://github.com/Slamtec/sllidar_ros2.git /ros2_ws/src/sllidar_ros2 && \
    rosdep update --rosdistro $ROS_DISTRO && \
    rosdep install --from-paths src --ignore-src -y

# Build
RUN source /opt/ros/$ROS_DISTRO/setup.bash && \
    colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release && \
    echo $(cat /ros2_ws/src/sllidar_ros2/package.xml | grep '<version>' | sed -r 's/.*<version>([0-9]+.[0-9]+.[0-9]+)<\/version>/\1/g') > /version.txt && \
    rm -rf build log

# =========================== final stage ===============================
FROM husarnet/ros:${PREFIX}${ROS_DISTRO}-ros-core AS final-stage

ARG PREFIX

COPY --from=pkg-builder /ros2_ws /ros2_ws
COPY --from=pkg-builder /version.txt  /version.txt
COPY ./husarion_utils /husarion_utils

# Ensure LIDAR stops spinning on container shutdown
STOPSIGNAL SIGINT
