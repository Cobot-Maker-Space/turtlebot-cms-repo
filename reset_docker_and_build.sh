#!/bin/bash

# --- CLEANUP SECTION ---
echo "==============================="
echo "DOCKER CLEANUP"
echo "==============================="
read -p "Perform FULL system cleanup? (Removes ALL images/volumes) [y/N]: " CLEAN_ALL

# Convert input to lowercase
CLEAN_ALL=${CLEAN_ALL,,}

if [[ "$CLEAN_ALL" == "y" ]]; then
    echo "Performing scorched earth cleanup..."
    docker stop $(docker ps -aq) 2>/dev/null
    docker rm -f $(docker ps -aq) 2>/dev/null
    docker rmi -f $(docker images -aq) 2>/dev/null
    docker volume rm $(docker volume ls -q) 2>/dev/null
    docker system prune -a -f --volumes
else
    echo "Targeted cleanup: Removing only 'my-devcontainer-image'..."
    # Stop and remove any container using that specific image
    CONTAINER_ID=$(docker ps -a -q --filter ancestor=my-devcontainer-image:latest)
    if [ -n "$CONTAINER_ID" ]; then
        docker stop $CONTAINER_ID 2>/dev/null
        docker rm -f $CONTAINER_ID 2>/dev/null
    fi
    # Remove the specific image
    docker rmi -f my-devcontainer-image:latest 2>/dev/null
fi

echo "Cleanup complete."

# --- PATH SELECTION SECTION ---
DEFAULT_PATH="$HOME/turtlebot-cms-repo/src/.devcontainer"

echo ""
echo "==============================="
echo "BUILD CONFIGURATION"
echo "==============================="
echo "Where is your .devcontainer folder?"
echo "Press ENTER for default: $DEFAULT_PATH"
read -p "Path: " USER_PATH

# Fallback to default if empty, a small change for git bash completion
TARGET_DIR="${USER_PATH:-$DEFAULT_PATH}"
# Expand tilde (~) if present
TARGET_DIR="${TARGET_DIR/#\~/$HOME}"

echo "Moving to: $TARGET_DIR"

if cd "$TARGET_DIR" 2>/dev/null; then
    if [ -f "Dockerfile" ] || [ -f "dockerfile" ]; then
        echo "Building image 'my-devcontainer-image:latest'..."
        docker build -t my-devcontainer-image:latest .
        echo "==============================="
        echo "Build complete."
        echo "==============================="
    else
        echo "Error: No Dockerfile found in $TARGET_DIR"
        echo "Go to the folder with your Dockerfile and run:"
        echo "docker build -t my-devcontainer-image:latest ."
        exit 1
    fi
else
    echo "Error: Directory '$TARGET_DIR' not found!"
    echo "Check your path and try again."
    echo "Manual command: docker build -t my-devcontainer-image:latest ."
    exit 1
fi
