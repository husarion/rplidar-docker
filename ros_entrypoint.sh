#!/bin/bash
set -e

# setup ros environment
source "/opt/ros/melodic/setup.bash"
source "/opt/ros/ros_ws/devel/setup.bash"

exec "$@"