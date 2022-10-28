ARG ROS_DISTRO=noetic

FROM ros:$ROS_DISTRO-ros-base AS pkg-builder

SHELL ["/bin/bash", "-c"]

WORKDIR /ros_ws

RUN apt update && apt install -y \
        git

# create ROS workspace and clone rplidar node repository
RUN mkdir -p src && \
    git clone https://github.com/Slamtec/rplidar_ros.git --branch=master src/rplidar_ros && \
    cd src/rplidar_ros && \
    git checkout 7b011f142b489d448492b5e6a683293f1e482aaa

# build packages
RUN source /opt/ros/$ROS_DISTRO/setup.bash && \
    catkin_make -DCATKIN_ENABLE_TESTING=0 -DCMAKE_BUILD_TYPE=Release

FROM ros:$ROS_DISTRO-ros-core

# select bash as default shell
SHELL ["/bin/bash", "-c"]

WORKDIR /ros_ws

COPY --from=pkg-builder /ros_ws /ros_ws

RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> ~/.bashrc
RUN echo "source /ros_ws/devel/setup.bash" >> ~/.bashrc

# setup entrypoint
COPY ./ros_entrypoint.sh /