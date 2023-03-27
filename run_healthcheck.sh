#!/bin/bash

MYDISTRO=${PREFIX_ENV:-ros}
MYDISTRO=${MYDISTRO//-/}

source /opt/$MYDISTRO/$ROS_DISTRO/setup.bash
/healthcheck.py