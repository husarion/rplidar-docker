# Define build stage for creating ROS packages
ARG ROS_DISTRO=humble
ARG PREFIX=

FROM husarnet/ros:$ROS_DISTRO-ros-base AS pkg-builder

SHELL ["/bin/bash", "-c"]

WORKDIR /ros2_ws

# Clone and install dependencies
RUN git clone https://github.com/husarion/sllidar_ros2.git /ros2_ws/src/sllidar_ros2 && \
    rosdep update --rosdistro $ROS_DISTRO && \
    rosdep install --from-paths src --ignore-src -y

# Create health check package
RUN cd src/ && \
    source /opt/ros/$ROS_DISTRO/setup.bash && \
    ros2 pkg create healthcheck_pkg --build-type ament_cmake --dependencies rclcpp sensor_msgs && \
    sed -i '/find_package(sensor_msgs REQUIRED)/a \
            add_executable(healthcheck_node src/healthcheck.cpp)\n \
            ament_target_dependencies(healthcheck_node rclcpp sensor_msgs)\n \
            install(TARGETS healthcheck_node DESTINATION lib/${PROJECT_NAME})' \
            /ros2_ws/src/healthcheck_pkg/CMakeLists.txt

COPY ./healthcheck.cpp /ros2_ws/src/healthcheck_pkg/src/

# Build
RUN source /opt/ros/$ROS_DISTRO/setup.bash && \
    colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release && \
    rm -rf build log

# Second stage - Deploy the built packages
FROM husarnet/ros:${PREFIX}${ROS_DISTRO}-ros-core

ARG PREFIX
ENV PREFIX_ENV=$PREFIX

SHELL ["/bin/bash", "-c"]

COPY --from=pkg-builder /ros2_ws /ros2_ws

RUN echo $(cat /ros2_ws/src/sllidar_ros2/package.xml | grep '<version>' | sed -r 's/.*<version>([0-9]+.[0-9]+.[0-9]+)<\/version>/\1/g') > /version.txt

# Run healthcheck in background
RUN if [ -f "/ros_entrypoint.sh" ]; then \
        sed -i '/test -f "\/ros2_ws\/install\/setup.bash" && source "\/ros2_ws\/install\/setup.bash"/a \
        ros2 run healthcheck_pkg healthcheck_node &' \
        /ros_entrypoint.sh; \
    else \
        sed -i '/test -f "\/ros2_ws\/install\/setup.bash" && source "\/ros2_ws\/install\/setup.bash"/a \
        ros2 run healthcheck_pkg healthcheck_node &' \
        /vulcanexus_entrypoint.sh; \
    fi

COPY ./healthcheck.sh /
HEALTHCHECK --interval=2s --timeout=1s --start-period=20s --retries=1 \
    CMD ["/healthcheck.sh"]

# Ensure LIDAR stops spinning on container shutdown
STOPSIGNAL SIGINT
