cmake_minimum_required(VERSION 2.8.3)
project(husarion_rplidar)

catkin_package(
  CATKIN_DEPENDS rplidar_ros
)

install(DIRECTORY launch
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
)