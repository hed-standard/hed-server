#!/bin/bash

# deploy.sh - Script to build and deploy a Docker container for the HEDTools online validator
# Usage: ./deploy.sh [branch] [environment] [bind_address]
# Environment can be 'prod' or 'dev' (defaults to 'prod')
# bind_address can be an IP like 0.0.0.0 (default) or 127.0.0.1 to restrict to localhost
#
# The script can be run from:
#   1. Inside the hed-server repo checkout (auto-detected, no clone needed)
#   2. A clean deploy directory (will clone from GitHub)
#   3. A directory with an existing hed-server/ subdirectory (reuses it)
#   4. With LOCAL_REPO set to copy from a local checkout:
#      LOCAL_REPO=/path/to/hed-server sudo bash deploy.sh main dev

##### Constants
BRANCH="${1:-main}"
ENVIRONMENT="${2:-prod}"
BIND_ADDRESS="${3:-0.0.0.0}"
DEPLOY_DIR=$(pwd)
RUNNING_IN_REPO=false

# Detect if we're running from inside the hed-server repo itself
if [ -d "${DEPLOY_DIR}/hedweb" ] && [ -d "${DEPLOY_DIR}/deploy" ] && [ -f "${DEPLOY_DIR}/pyproject.toml" ]; then
    RUNNING_IN_REPO=true
fi

# Set environment-specific variables
if [ "$ENVIRONMENT" = "dev" ]; then
    IMAGE_NAME="hedtools_dev:latest"
    CONTAINER_NAME="hedtools_dev"
    HOST_PORT=33004
    URL_PREFIX="/hed_dev"
    STATIC_URL_PATH="/hed_dev/hedweb/static"
    HED_INSTALL_SOURCE="main"
else
    IMAGE_NAME="hedtools:latest"
    CONTAINER_NAME="hedtools"
    HOST_PORT=33000
    URL_PREFIX="/hed"
    STATIC_URL_PATH="/hed/hedweb/static"
    HED_INSTALL_SOURCE="pypi"
fi

GIT_WEB_REPO_URL="https://github.com/hed-standard/hed-server"
GIT_WEB_REPO_BRANCH="$BRANCH"
CONTAINER_PORT=80

# Directory paths
GIT_HED_SERVER_DIR="${DEPLOY_DIR}/hed-server"
CODE_DEPLOY_DIR="${DEPLOY_DIR}/hedtools"
SOURCE_DEPLOY_DIR="${GIT_HED_SERVER_DIR}/deploy"
CONFIG_FILE="${CODE_DEPLOY_DIR}/config.py"

# Source files
BASE_CONFIG_FILE="${SOURCE_DEPLOY_DIR}/base_config.py"
SOURCE_DOCKERFILE="${SOURCE_DEPLOY_DIR}/Dockerfile"
LOGROTATE_CONF_FILE="${SOURCE_DEPLOY_DIR}/gunicorn-logrotate.conf"
WEB_CODE_DIR="${GIT_HED_SERVER_DIR}/hedweb"

##### Functions

# Print error message and exit
error_exit() {
    printf '[ERROR] %b\n' "$1" >&2
    exit 1
}

# Clone or locate the repository
clone_github_repos() {
    if [ "${RUNNING_IN_REPO}" = true ]; then
        echo "Running from inside the hed-server repo at ${DEPLOY_DIR}..."
        GIT_HED_SERVER_DIR="${DEPLOY_DIR}"
        SOURCE_DEPLOY_DIR="${GIT_HED_SERVER_DIR}/deploy"
        BASE_CONFIG_FILE="${SOURCE_DEPLOY_DIR}/base_config.py"
        SOURCE_DOCKERFILE="${SOURCE_DEPLOY_DIR}/Dockerfile"
        LOGROTATE_CONF_FILE="${SOURCE_DEPLOY_DIR}/gunicorn-logrotate.conf"
        WEB_CODE_DIR="${GIT_HED_SERVER_DIR}/hedweb"
        return 0
    fi

    if [ -d "${GIT_HED_SERVER_DIR}" ]; then
        echo "Using existing repository at ${GIT_HED_SERVER_DIR}..."
        return 0
    fi

    if [ -n "${LOCAL_REPO}" ]; then
        echo "Copying local repository from ${LOCAL_REPO} to ${GIT_HED_SERVER_DIR}..."
        cp -r "${LOCAL_REPO}" "${GIT_HED_SERVER_DIR}" || error_exit "Failed to copy local repo from ${LOCAL_REPO}"
        return 0
    fi

    echo "Cloning repository ${GIT_WEB_REPO_URL} into ${DEPLOY_DIR} using branch ${GIT_WEB_REPO_BRANCH}..."
    git clone --branch "${GIT_WEB_REPO_BRANCH}" "${GIT_WEB_REPO_URL}" || error_exit "Failed to clone repo ${GIT_WEB_REPO_URL}.\nIf the network is unavailable, either:\n  1. Run this script from inside the hed-server repo checkout\n  2. Place the repo at ${GIT_HED_SERVER_DIR} before running this script\n  3. Place an existing hed-server/ subdirectory in the deploy directory\n  4. Set LOCAL_REPO=/path/to/hed-server to copy from a local checkout"
}

# Create the necessary web directory structure and copy config files
setup_web_directory() {
    echo "Setting up web directory for ${ENVIRONMENT} environment..."
    mkdir -p "${CODE_DEPLOY_DIR}"
    cp "${BASE_CONFIG_FILE}" "${CONFIG_FILE}" || error_exit "Failed to copy base config file"
    cp "${SOURCE_DOCKERFILE}" "${DEPLOY_DIR}/Dockerfile" || error_exit "Failed to copy Dockerfile"
    cp "${LOGROTATE_CONF_FILE}" "${DEPLOY_DIR}/gunicorn-logrotate.conf" || error_exit "Failed to copy gunicorn logrotate config"
    # When running from inside the repo, these are already in place
    if [ "${RUNNING_IN_REPO}" = false ]; then
        cp "${GIT_HED_SERVER_DIR}/pyproject.toml" "${DEPLOY_DIR}/pyproject.toml" || error_exit "Failed to copy pyproject.toml"
        cp "${GIT_HED_SERVER_DIR}/setup.py" "${DEPLOY_DIR}/setup.py" 2>/dev/null || echo "No setup.py found (optional)"
        cp "${GIT_HED_SERVER_DIR}/README.md" "${DEPLOY_DIR}/README.md" || error_exit "Failed to copy README.md"
    fi
    cp -r "${WEB_CODE_DIR}" "${CODE_DEPLOY_DIR}" || error_exit "Failed to copy web code"
}

# Build the Docker image
build_docker_image() {
    echo "Building Docker image ${IMAGE_NAME} for ${ENVIRONMENT} environment..."
    docker build --build-arg HED_INSTALL_SOURCE="${HED_INSTALL_SOURCE}" --build-arg CACHE_BUST="$(date +%s)" -t "${IMAGE_NAME}" . || error_exit "Failed to build Docker image"
}

# Stop and remove existing container
stop_existing_container() {
    echo "Stopping and removing existing container ${CONTAINER_NAME}..."
    docker stop "${CONTAINER_NAME}" 2>/dev/null || echo "Container ${CONTAINER_NAME} was not running"
    docker rm "${CONTAINER_NAME}" 2>/dev/null || echo "Container ${CONTAINER_NAME} did not exist"
}

# Run the Docker container
run_docker_container() {
    echo "Running Docker container ${CONTAINER_NAME} on ${BIND_ADDRESS}:${HOST_PORT}..."
    docker run -d \
        --name "${CONTAINER_NAME}" \
        -p "${BIND_ADDRESS}:${HOST_PORT}:${CONTAINER_PORT}" \
        -e HED_URL_PREFIX="${URL_PREFIX}" \
        -e HED_STATIC_URL_PATH="${STATIC_URL_PATH}" \
        "${IMAGE_NAME}" || error_exit "Failed to run Docker container"
}

# Clean up deployment files
cleanup() {
    echo "Cleaning up deployment files..."
    rm -rf "${CODE_DEPLOY_DIR}"
    if [ "${RUNNING_IN_REPO}" = true ]; then
        # Only remove files we created; do NOT delete the repo itself
        rm -f "${DEPLOY_DIR}/Dockerfile" "${DEPLOY_DIR}/gunicorn-logrotate.conf"
    else
        rm -rf "${GIT_HED_SERVER_DIR}" "Dockerfile" "gunicorn-logrotate.conf" "pyproject.toml" "setup.py" "README.md"
    fi
}

##### Main execution
echo "Starting deployment for ${ENVIRONMENT} environment..."
echo "Branch: ${GIT_WEB_REPO_BRANCH}"
echo "Image: ${IMAGE_NAME}"
echo "Container: ${CONTAINER_NAME}"
echo "Port: ${HOST_PORT}"
echo "Bind address: ${BIND_ADDRESS}"

clone_github_repos
setup_web_directory
build_docker_image
stop_existing_container
run_docker_container
cleanup

echo "Deployment completed successfully!"
echo "Application is running at: http://localhost:${HOST_PORT}${URL_PREFIX}"
