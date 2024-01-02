from launch import LaunchDescription
from launch.actions import (
    DeclareLaunchArgument,
    IncludeLaunchDescription,
    GroupAction,
    OpaqueFunction,
)
from launch.launch_description_sources import PythonLaunchDescriptionSource
from launch_ros.actions import Node, PushRosNamespace, SetRemap
from launch.substitutions import EnvironmentVariable, LaunchConfiguration, PathJoinSubstitution
from launch_ros.substitutions import FindPackageShare


def launch_setup(context, *args, **kwargs):
    launch_file = LaunchConfiguration("launch_file").perform(context)
    serial_baudrate = LaunchConfiguration("serial_baudrate").perform(context)
    serial_port = LaunchConfiguration("serial_port").perform(context)
    robot_namespace = LaunchConfiguration("robot_namespace").perform(context)
    device_namespace = LaunchConfiguration("device_namespace").perform(context)

    if device_namespace:
        frame_id = device_namespace + "_link"
    else:
        frame_id = "scan"

    rplidar_actions = []

    # Remappings
    if robot_namespace:
        rplidar_actions.append(SetRemap("/tf", f"/{robot_namespace}/tf"))
        rplidar_actions.append(SetRemap("/tf_static", f"/{robot_namespace}/tf_static"))

    # Device Namespace
    rplidar_actions.append(PushRosNamespace(device_namespace))

    # Rplidar
    rplidar_path = PathJoinSubstitution([FindPackageShare("sllidar_ros2"), "launch", launch_file])
    rplidar_actions.append(
        IncludeLaunchDescription(
            PythonLaunchDescriptionSource([rplidar_path]),
            launch_arguments={
                "frame_id": frame_id,
                "serial_baudrate": serial_baudrate,
                "serial_port": serial_port,
            }.items(),
        )
    )

    rplidar_ns = GroupAction(actions=rplidar_actions)

    # Health check
    healthcheck_node = Node(
        package="healthcheck_pkg",
        executable="healthcheck_node",
        name="healthcheck_rplidar",
        namespace=device_namespace,
        output="screen",
    )

    return [PushRosNamespace(robot_namespace), rplidar_ns, healthcheck_node]


def generate_launch_description():
    return LaunchDescription(
        [
            DeclareLaunchArgument(
                "launch_file",
                default_value="sllidar_launch.py",
                description="Select launch file from repo `sllidar_ros2`, based on plugged lidar model",
            ),
            DeclareLaunchArgument(
                "serial_baudrate",
                default_value="115200",
                description="Specifying usb port baudrate to connected lidar",
            ),
            DeclareLaunchArgument(
                "serial_port",
                default_value="/dev/ttyUSB0",
                description="Specifying usb port to connected lidar",
            ),
            DeclareLaunchArgument(
                "robot_namespace",
                default_value=EnvironmentVariable("ROS_NAMESPACE", default_value=""),
                description="Namespace which will appear in front of all topics (including /tf and /tf_static).",
            ),
            DeclareLaunchArgument(
                "device_namespace",
                default_value="",
                description="Sensor namespace that will appear before all non absolute topics and TF frames, used for distinguishing multiple cameras on the same robot.",
            ),
            OpaqueFunction(function=launch_setup),
        ]
    )
