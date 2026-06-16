# FROM ros:humble
FROM my-devcontainer-image:latest

ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ENV DEBIAN_FRONTEND=noninteractive
ENV SHELL=/bin/bash

RUN groupadd --gid $USER_GID $USERNAME \
 && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
 && apt-get update \
 && apt-get install -y sudo \
 && echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
 && chmod 0440 /etc/sudoers.d/$USERNAME \
 && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-opencv \
    libopencv-dev \
    net-tools \
    nano \
    iputils-ping \
    curl \
    fswebcam \
    gnupg2 \
    lsb-release \
    build-essential \
    mesa-utils \
    wget \
    ca-certificates \
    gnupg \
    v4l-utils \
    python3-colcon-common-extensions \
    ros-humble-navigation2 \
    ros-humble-nav2-bringup \
    ros-humble-slam-toolbox \
    ros-humble-teleop-twist-keyboard \
    ros-humble-gazebo-ros-pkgs \
    ros-humble-gazebo-plugins \
    ros-humble-cv-bridge \
    # "ros-humble-rqt*" \
    ros-humble-cartographer \
    ros-humble-cartographer-ros \
    ros-humble-rviz2 \
    ubuntu-mate-desktop \
    openbox \
    x11-apps \
    novnc \
    websockify \
    tigervnc-standalone-server \
    tigervnc-common \
    supervisor \
    git \
    tini \
    locales \
    tzdata \
    dos2unix \
 && rm -rf /var/lib/apt/lists/*

RUN pip install pyrealsense2 paho-mqtt flask flask-ask-sdk ask-sdk || true

COPY setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

RUN mkdir -p /etc/udev/rules.d \
 && wget https://raw.githubusercontent.com/IntelRealSense/librealsense/master/config/99-realsense-libusb.rules \
    -O /etc/udev/rules.d/99-realsense-libusb.rules \
 && echo 'SUBSYSTEM=="iio", MODE="0666", GROUP="plugdev"' >> /etc/udev/rules.d/99-realsense-libusb.rules \
 && echo 'SUBSYSTEM=="video4linux", MODE="0666", GROUP="video"' >> /etc/udev/rules.d/99-realsense-libusb.rules || true

RUN usermod -aG video,dialout,plugdev,input $USERNAME || true
RUN echo "source /opt/ros/humble/setup.bash && source /home/ros2_ws/install/setup.bash" >> /home/$USERNAME/.bashrc

USER $USERNAME

EXPOSE 8080
CMD ["/bin/bash"]