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
git clone https://github.com/Cobot-Maker-Space/turtlebot-cms-repo.git
```

---

### 2. Build the Container Image

This repository includes a build helper script for Linux and a native Windows helper for PowerShell/cmd.

#### Linux (bash / WSL)

1. Open a terminal.
2. Go to the repository root:

```bash
cd ~/turtlebot-cms-repo
```
3. Make the script executable once:

```bash
sudo chmod +x reset_docker_and_build.sh
```
4. Run the build script:

```bash
./reset_docker_and_build.sh
```

If the script is already executable, you can omit the `chmod` command.

#### Windows (PowerShell)

1. Open PowerShell.
2. Change to your repository folder:

```powershell
cd $HOME\turtlebot-cms-repo
```
3. Run the helper script:

```powershell
.\windows_reset_docker_script.ps1
```

If PowerShell blocks the script, run:

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force
.\windows_reset_docker_script.ps1
```

#### Windows (cmd.exe)

1. Open Command Prompt.
2. Change to the repository directory:

```cmd
cd %USERPROFILE%\turtlebot-cms-repo
```
3. Run the wrapper script:

```cmd
windows_reset_docker_script.cmd
```

---

### 3. Open in Dev Container

#### Linux / macOS

1. From the host terminal run:

```bash
xhost +local:docker
```

2. Launch VS Code from the source folder:

```bash
cd ~/turtlebot-cms-repo/src
code .
```

#### Windows

1. Open VS Code.
2. Choose `File > Open Folder` and select the folder:

```text
C:\Users\<your-user>\turtlebot-cms-repo\src
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
