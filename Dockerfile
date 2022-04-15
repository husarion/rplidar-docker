FROM ros:galactic-ros-base

# select bash as default shell
SHELL ["/bin/bash", "-c"]

WORKDIR /ros2_ws

# install everything needed
RUN apt-get update && apt-get install -y \
        ros-$ROS_DISTRO-rmw-fastrtps-cpp && \
    apt-get upgrade -y && \
    git clone https://github.com/Slamtec/rplidar_ros.git --branch=ros2 /ros2_ws/src/rplidar_ros && \
    source /opt/ros/$ROS_DISTRO/setup.bash && \
    colcon build --symlink-install && \
    # make the image smaller     
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV RMW_IMPLEMENTATION=rmw_fastrtps_cpp

COPY ros_entrypoint.sh /