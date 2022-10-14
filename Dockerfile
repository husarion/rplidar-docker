FROM ros:melodic-ros-base AS pkg-builder

SHELL ["/bin/bash", "-c"]

WORKDIR /ros_ws

# create ROS workspace and clone rplidar node repository
RUN mkdir -p src && \
    git clone https://github.com/Slamtec/rplidar_ros.git --branch=master src/rplidar_ros && \
    cd src/rplidar_ros && \
    git checkout c72b8c73686fc928bb611662359a46a559c575d8

# build packages
RUN source /opt/ros/melodic/setup.bash && \
    catkin_make -DCATKIN_ENABLE_TESTING=0 -DCMAKE_BUILD_TYPE=Release

FROM ros:melodic-ros-core

# select bash as default shell
SHELL ["/bin/bash", "-c"]

WORKDIR /ros_ws

COPY --from=pkg-builder /ros_ws /ros_ws

RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> ~/.bashrc
RUN echo "source /ros_ws/devel/setup.bash" >> ~/.bashrc

# setup entrypoint
COPY ./ros_entrypoint.sh /

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]