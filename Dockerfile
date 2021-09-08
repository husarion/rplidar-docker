FROM ros:melodic-ros-base

SHELL ["/bin/bash", "-c"]

WORKDIR /app

# create ROS workspace and clone rplidar node repository
RUN mkdir -p ros_ws/src \
    && git clone https://github.com/Slamtec/rplidar_ros.git --branch=master ros_ws/src/rplidar_ros

# build packages
RUN cd ros_ws \
    && source /opt/ros/melodic/setup.bash \
    && catkin_make -DCATKIN_ENABLE_TESTING=0 -DCMAKE_BUILD_TYPE=Release

# clear ubuntu packages
RUN apt clean && \
    rm -rf /var/lib/apt/lists/*

# setup entrypoint
COPY ./ros_entrypoint.sh /

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]