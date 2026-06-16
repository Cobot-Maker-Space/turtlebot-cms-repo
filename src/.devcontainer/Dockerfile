# FROM ros:humble
FROM my-devcontainer-image:latest

ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
&& useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
&& apt-get update \
&& apt-get install -y sudo \
&& echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
&& chmod 0440 /etc/sudoers.d/$USERNAME
# Set environment for ROS 2
ENV SHELL=/bin/bash

# Pre-install system dependencies and ROS packages
RUN apt-get update && apt-get install -y \
    nvidia-cuda-toolkit \
    python3-pip \
    python3-opencv\
    libopencv-dev\
    net-tools \
    nano \
    iputils-ping \
    curl \
    fswebcam \
    nano \
    gnupg2 \
    lsb-release \
    sudo \
    build-essential \
    mesa-utils\
    wget \
    ca-certificates \
    gnupg \
    curl \
    v4l-utils \
    python3-colcon-common-extensions \
    ros-humble-navigation2 \
    ros-humble-nav2-bringup \
    ros-humble-slam-toolbox \
    ros-humble-teleop-twist-keyboard \
    ros-humble-gazebo-ros-pkgs\
    ros-humble-gazebo-plugins \
    ros-humble-cv-bridge \
    ros-humble-rqt* \
    # ros-humble-gazebo-*\
    # ros-humble-ros-gz\
    ros-humble-cartographer \
    ros-humble-cartographer-ros \
    ros-humble-rviz2 \
    && rm -rf /var/lib/apt/lists/*

RUN pip install pyrealsense2
RUN pip install paho-mqtt
RUN pip install flask flask-ask-sdk ask-sdk

RUN mkdir -p /etc/udev/rules.d && \
    wget https://raw.githubusercontent.com/IntelRealSense/librealsense/master/config/99-realsense-libusb.rules \
    -O /etc/udev/rules.d/99-realsense-libusb.rules && \
    # Add additional permissions for HID sensors (IMU)
    echo 'SUBSYSTEM=="iio", MODE="0666", GROUP="plugdev"' >> /etc/udev/rules.d/99-realsense-libusb.rules && \
    echo 'SUBSYSTEM=="video4linux", MODE="0666", GROUP="video"' >> /etc/udev/rules.d/99-realsense-libusb.rules


RUN usermod -aG video $USERNAME
RUN usermod -aG dialout $USERNAME
RUN usermod -aG plugdev $USERNAME
RUN usermod -aG input $USERNAME
    
# Source ROS setup
RUN echo "source /opt/ros/humble/setup.bash && source /home/ros2_ws/install/setup.bash" >> /home/$USERNAME/.bashrc

# Set default user
USER $USERNAME

CMD ["/bin/bash"]
