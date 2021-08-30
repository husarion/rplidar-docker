from ros:melodic

SHELL ["/bin/bash", "-c"]

WORKDIR /app

# create ROS workspace and clone rplidar node repository
RUN mkdir -p ros_ws/src \
    && git clone https://github.com/Slamtec/rplidar_ros.git --branch=master ros_ws/src/rplidar_ros

# copy husarion launch files to docker
COPY ./husarion_rplidar /app/ros_ws/src/husarion_rplidar

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