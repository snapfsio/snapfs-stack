#!/usr/bin/env sh
#
# SnapFS stack installer
#
# Usage (Linux/macOS):
#   curl -fsSL https://raw.githubusercontent.com/snapfsio/snapfs-stack/master/install.sh | sh
#
# Or, if already cloned:
#   ./install.sh

set -u

REPO_URL="https://github.com/snapfsio/snapfs-stack.git"
STACK_DIR="snapfs-stack"
COMPOSE_FILE="compose.yml"
LOCAL_COMPOSE_FALLBACK="snapfs-compose.yml"

# Simple helper
have_cmd() {
    command -v "$1" >/dev/null 2>&1
}

echo "==> SnapFS stack installer"

# 1) Check Docker
if ! have_cmd docker; then
    echo "ERROR: docker not found in PATH."
    echo "Please install Docker first: https://docs.docker.com/get-docker/"
    exit 1
fi

# 2) Check Compose (prefer 'docker compose', fallback to 'docker-compose')
COMPOSE_CMD=""
if docker compose version >/dev/null 2>&1; then
    COMPOSE_CMD="docker compose"
elif have_cmd docker-compose; then
    COMPOSE_CMD="docker-compose"
else
    echo "ERROR: Docker Compose not found."
    echo "This script requires either:"
    echo "  - 'docker compose' (Compose V2), or"
    echo "  - 'docker-compose' (Compose V1)."
    exit 1
fi

echo "==> Using compose command: ${COMPOSE_CMD}"

# 3) Are we already inside a snapfs-stack working directory?
if [ -f "${COMPOSE_FILE}" ]; then
    echo "==> Found ${COMPOSE_FILE} in current directory."
    echo "==> Bringing up SnapFS stack..."
    ${COMPOSE_CMD} up -d
    echo "==> Done. Check status with: ${COMPOSE_CMD} ps"
    exit 0
fi

# 4) If a snapfs-stack directory already exists with a compose file, use it
if [ -d "${STACK_DIR}" ] && [ -f "${STACK_DIR}/${COMPOSE_FILE}" ]; then
    echo "==> Found existing ${STACK_DIR}/${COMPOSE_FILE}."
    echo "==> Changing into ${STACK_DIR} and bringing up stack..."
    cd "${STACK_DIR}" || exit 1
    ${COMPOSE_CMD} up -d
    echo "==> Done. Check status with: ${COMPOSE_CMD} ps"
    exit 0
fi

# 5) Try to clone the repo if git is available
if have_cmd git; then
    echo "==> Cloning ${REPO_URL} into ${STACK_DIR}..."
    git clone "${REPO_URL}" "${STACK_DIR}" || {
        echo "ERROR: git clone failed."
        exit 1
    }
    cd "${STACK_DIR}" || exit 1
    echo "==> Bringing up SnapFS stack from ${STACK_DIR}/${COMPOSE_FILE}..."
    ${COMPOSE_CMD} up -d
    echo "==> Done. Check status with: ${COMPOSE_CMD} ps"
    exit 0
fi

# 6) Fallback: no git → download compose.yml only
echo "==> git not found. Falling back to downloading compose.yml only."

COMPOSE_URL="https://raw.githubusercontent.com/snapfsio/snapfs-stack/master/${COMPOSE_FILE}"

if have_cmd curl; then
    echo "==> Downloading ${COMPOSE_URL} -> ${LOCAL_COMPOSE_FALLBACK}"
    curl -fsSL "${COMPOSE_URL}" -o "${LOCAL_COMPOSE_FALLBACK}" || {
        echo "ERROR: Failed to download compose file via curl."
        exit 1
    }
elif have_cmd wget; then
    echo "==> Downloading ${COMPOSE_URL} -> ${LOCAL_COMPOSE_FALLBACK}"
    wget -qO "${LOCAL_COMPOSE_FALLBACK}" "${COMPOSE_URL}" || {
        echo "ERROR: Failed to download compose file via wget."
        exit 1
    }
else
    echo "ERROR: Neither git, curl, nor wget is available."
    echo "Please install one of them and re-run this script."
    exit 1
fi

echo "==> Bringing up SnapFS stack from ${LOCAL_COMPOSE_FALLBACK}..."
${COMPOSE_CMD} -f "${LOCAL_COMPOSE_FALLBACK}" up -d
echo "==> Done. Check status with: ${COMPOSE_CMD} -f ${LOCAL_COMPOSE_FALLBACK} ps"
