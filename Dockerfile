# Define build stage for creating ROS packages
ARG ROS_DISTRO=humble
ARG PREFIX=

# =========================== package builder ===============================
FROM husarnet/ros:$ROS_DISTRO-ros-base AS pkg-builder

WORKDIR /ros2_ws

# Setup workspace
RUN git clone https://github.com/Slamtec/sllidar_ros2.git /ros2_ws/src/sllidar_ros2 && \
    cp /ros2_ws/src/sllidar_ros2/launch/sllidar_a1_launch.py \
       /ros2_ws/src/sllidar_ros2/launch/sllidar_launch.py && \
    rosdep update --rosdistro $ROS_DISTRO && \
    rosdep install --from-paths src --ignore-src -y

# Create healthcheck package
RUN cd src/ && \
    source /opt/ros/$ROS_DISTRO/setup.bash && \
    ros2 pkg create healthcheck_pkg --build-type ament_cmake --dependencies rclcpp sensor_msgs && \
    sed -i '/find_package(sensor_msgs REQUIRED)/a \
            add_executable(healthcheck_node src/healthcheck.cpp)\n \
            ament_target_dependencies(healthcheck_node rclcpp sensor_msgs)\n \
            install(TARGETS healthcheck_node DESTINATION lib/${PROJECT_NAME})' \
            /ros2_ws/src/healthcheck_pkg/CMakeLists.txt

COPY ./husarion_utils/healthcheck.cpp /ros2_ws/src/healthcheck_pkg/src/

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

HEALTHCHECK --interval=2s --timeout=1s --start-period=20s --retries=1 \
    CMD ["/husarion_utils/healthcheck.sh"]

# Ensure LIDAR stops spinning on container shutdown
STOPSIGNAL SIGINT
