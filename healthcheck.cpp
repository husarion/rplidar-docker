#include "rclcpp/rclcpp.hpp"
#include "cstdlib"

bool checkROS2TopicExistence(const std::string& topic_name) {
    rclcpp::init(0, nullptr);

    auto node = std::make_shared<rclcpp::Node>("health_check_node");

    // Create a client to check if the topic is available
    auto topic_exists = node->get_topic_names_and_types();

    for (const auto& topic : topic_exists) {
        if (topic.first == topic_name) {
            return true;
        }
    }

    return false;
}

int main() {
    std::string topic_name = "/scan";

    if (checkROS2TopicExistence(topic_name)) {
        return EXIT_SUCCESS;
    } else {
        return EXIT_FAILURE;
    }
}
