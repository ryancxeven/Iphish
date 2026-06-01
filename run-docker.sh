#!/bin/bash

# Docker Wrapper Script for IPhish (^.^)

BASE_DIR=$(realpath "$(dirname "$BASH_SOURCE")")

# Create auth directory if not exists

if [[ ! -d "$BASE_DIR/auth" ]]; then
echo "[*] Creating auth directory..."
mkdir -p "$BASE_DIR/auth"
fi

CONTAINER="iphish"
IMAGE="ryancxeven/iphish:latest"
IMG_MIRROR="ghcr.io/ryancxeven/iphish:latest"

MOUNT_LOCATION=${BASE_DIR}/auth

# Check existing containers

check_container=$(docker ps --all --format "{{.Names}}")

# Create container if not exists

if [[ ! $check_container == *"$CONTAINER"* ]]; then
echo "[*] Creating new container..."

```
docker create \
    --interactive --tty \
    --volume ${MOUNT_LOCATION}:/iphish/auth/ \
    --network host \
    --name "${CONTAINER}" \
    "${IMAGE}"
```

fi

# Start container

echo "[*] Starting IPhish container..."
docker start --interactive "${CONTAINER}"

# Alternative temporary container

# docker run --rm -ti \

# --network="host" \

# -v ${MOUNT_LOCATION}:/iphish/auth/ \

# --name "$CONTAINER" \

# "$IMAGE"
