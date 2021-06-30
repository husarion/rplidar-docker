from ros:melodic

RUN mkdir -p /opt/ros/ros_ws/src

RUN git clone -b master https://github.com/Slamtec/rplidar_ros.git /opt/ros/ros_ws/src/rplidar_ros

RUN bash -c "cd /opt/ros/ros_ws && source /opt/ros/melodic/setup.bash && catkin_make -DCATKIN_ENABLE_TESTING=0 -DCMAKE_BUILD_TYPE=Release"