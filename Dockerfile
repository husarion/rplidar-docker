from ros:melodic

SHELL ["/bin/bash", "-c"]

RUN mkdir -p /ros_ws/src \
    && git clone https://github.com/Slamtec/rplidar_ros.git --branch=master /ros_ws/src/rplidar_ros

COPY ./husarion_rplidar /ros_ws/src/husarion_rplidar

RUN cd ros_ws \
    && source /opt/ros/melodic/setup.bash \
    && catkin_make -DCATKIN_ENABLE_TESTING=0 -DCMAKE_BUILD_TYPE=Release

# setup entrypoint
COPY ./ros_entrypoint.sh /

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]