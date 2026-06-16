# ROS2 Humble Development Container 

This repository contains a ready-to-use **Docker-based ROS 2 Humble** development environment for working with **Nvidia GPUs**. It includes Visual Studio Code support, useful extensions, and common ROS 2 packages preinstalled (like ur3 drivers, moveit, etc.) — making it easy to get started with for simulation and development on any Linux machine powered by Nvidia GPUs. All the commands are provided with the assumption that you have cloned the repo in the home directory of the user. 

---

## 📦 Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Visual Studio Code](https://code.visualstudio.com/)
- [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

---

## 🔧 Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/Cobot-Maker-Space/ros2-container.git
```

---
### 2. Installing Nvidia GPU drivers

If you are cloning the repo on a fresh machine and or your own personal machine then skip STEP 2 and 3 and straight away go to STEP 4 as these would already be configured on a machine provided to you.

For these 2 scripts to run, you would require sudo access on the machine. The installation is set up to be performed in 2 steps.

1. First step requires purging all the existing nvidia drivers to stop the issue of version mismatch and installing the recommended drivers by your machine. Save your work before running this script as this step would require a reboot.

```bash
cd ~/ros2-container/src
sudo chmod +x part1_driver.sh
sudo ./part1_driver.sh
sudo reboot
```

2. After the machine has rebooted now we are going to install nvidia-container-toolkit to make the GPU work inside the docker container. This step wont require a reboot.

```bash
cd ~/ros2-container/src
sudo chmod +x part2_driver.sh
sudo ./part2_driver.sh
```

### 3. Creating the DOCKER image

#### Modify the Dockerfile

1. Navigate to the following directory:

```bash
   cd ~/ros2-container/src/.devcontainer/
```
2. Open the file via nano or via VS Code (your choice):

```bash
   nano Dockerfile
```
3. At the very top of the file, you will see:

```bash
   # FROM ros:humble

   FROM my-devcontainer-image:latest
```
4. Modify it so it becomes:

```bash
   FROM ros:humble

   # FROM my-devcontainer-image:latest
```
   In other words:

   * Uncomment the line: FROM ros:humble
   * Comment the line: FROM my-devcontainer-image:latest

5. Save and close the file.

#### Building the new Container

This script simply deletes all the docker containers and images if allowed yes and if no, then only deletes the Docker image required by this repo. You won't require sudo for this step if the script permisisons are already set to Executable.

```bash
cd ~/ros2-container
sudo chmod +x reset_docker_and_build.sh
./reset_docker_and_build.sh
```

Allow the build process to complete fully before proceeding.

#### Restore the Dockerfile

1. Navigate back to the file  via nano or via VS Code (your choice):

```bash
   nano Dockerfile
```
2. Revert the top lines back to:

```bash
   # FROM ros:humble

   FROM my-devcontainer-image:latest
```

   In other words:

   * Comment the line: FROM ros:humble
   * Uncomment the line: FROM my-devcontainer-image:latest


3. Save and close the file.



### 4. Opening in Dev Container

1.Open the PC's terminal and run:

```bash
xhost +local:docker
```

2. Launching VS Code.

```bash
cd ~/ros2-container/src
code .
```

3. You should see a `.devcontainer/` folder in the file tree.

Inside VS Code:
  - Press `Ctrl+Shift+P`
  - Type and select: `Dev Containers: Rebuild and Reopen in Container`
  - VS Code will now build and launch your ROS 2 container

If no option like that, go to Extensions and search for Devcontainers and Container tools and install them and try again.

---

### 4. Test the Setup

Inside the container terminal:

```bash
source /opt/ros/humble/setup.bash
ros2 topic list
```

If ROS 2 is installed correctly, you’ll see an empty or populated list depending on what's running.



## 🛠 Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| `Docker permission denied` | Make sure your user is added to the `docker` group: <br> `sudo usermod -aG docker $USER` <br> Then logout your user and then log back in and check. |
| `Cannot access /dev/video0` | Add your user to the `video` group: <br> `sudo usermod -aG video $USER` |
| When launching Gazebo simulations, if it takes too much time and exits at `Spawn service failed. Exiting.` | Do not press `Ctrl + C` Let it fail completely and cleanly and then close it and run it again. |
| Colcon build fails `Permission denied on log folder` | Run the command: <br> `sudo chmod 777 -R ~/ros2-container/cache/humble` <br> Then Try again with the colcon build command |
---

## 💡 Notes

- Default user inside container is `user` (sudo access).
- Workspace is mounted to `/home/ros2_ws/src`.
- Includes support for Gazebo, SLAM, Navigation2, Teleop, Cartographer, and more.
- VS Code extensions preinstalled for ROS, C++, Python, and Git.

---

edit this readme according to the current file of /src/.devcontainer/devcontainer.json as i have removed teh nvidia part and have deleted the part1 and aport 2 scripts so remove thing concerning them too and the new repo to be cloned has a new name "turtlrbot-cms-repo"