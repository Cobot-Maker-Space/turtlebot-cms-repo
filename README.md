# ROS2 Humble Development Container 

This repository contains a ready-to-use **Docker-based ROS 2 Humble** development environment. It includes Visual Studio Code support, useful extensions, and common ROS 2 packages preinstalled — making it easy to get started with simulation and development on Linux. All the commands are provided with the assumption that you have cloned the repo in the home directory of the user. 

---

## 📦 Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Visual Studio Code](https://code.visualstudio.com/)
- [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

---

## 🔧 Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/Cobot-Maker-Space/turtlrbot-cms-repo.git
```

---

### 2. Create the Docker image

#### Modify the Dockerfile

1. Navigate to the following directory:

```bash
   cd ~/turtlrbot-cms-repo/src/.devcontainer/
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
cd ~/turtlrbot-cms-repo
sudo chmod +x reset_docker_and_build.sh
./reset_docker_and_build.sh
```

If the script is already executable, you can omit the `chmod` command.

---

### 3. Open in Dev Container

1. From the host terminal run:

```bash
xhost +local:docker
```

2. Launch VS Code:

```bash
cd ~/turtlrbot-cms-repo/src
code .
```

3. In VS Code:
  - Press `Ctrl+Shift+P`
  - Select `Dev Containers: Rebuild and Reopen in Container`

If you do not see this option, install the `Dev Containers` or `Container Tools` extension and try again.

---

### 4. Test the Setup

Inside the container terminal:

```bash
source /opt/ros/humble/setup.bash
ros2 topic list
```

If ROS 2 is installed correctly, you’ll see a list of active topics or an empty list if nothing is running.


## 🛠 Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| `Docker permission denied` | Make sure your user is added to the `docker` group: <br> `sudo usermod -aG docker $USER` <br> Then logout and log back in. |
| `Cannot access /dev/video0` | Add your user to the `video` group: <br> `sudo usermod -aG video $USER` |
| When launching Gazebo simulations, if it takes too much time and exits at `Spawn service failed. Exiting.` | Let it fail completely and cleanly, then close it and run it again. |
| Colcon build fails `Permission denied on log folder` | Run: <br> `sudo chmod 777 -R ~/turtlrbot-cms-repo/cache/humble` <br> Then try again. |
---

## 💡 Notes

- Default user inside container is `user` (sudo access).
- Workspace is mounted to `/home/ros2_ws/src`.
- Includes support for Gazebo, SLAM, Navigation2, Teleop, Cartographer, and more.
- VS Code extensions preinstalled for ROS, C++, Python, and Git.

---
