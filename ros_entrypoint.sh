#!/bin/bash
set -e

MY_DISTRO=${PREFIX_ENV:-ros}
MY_DISTRO=${MY_DISTRO//-/}

# setup ROS2 environment
source /opt/$MY_DISTRO/$ROS_DISTRO/setup.bash
test -f "/ros2_ws/install/setup.bash" && source "/ros2_ws/install/setup.bash"

exec "$@"
