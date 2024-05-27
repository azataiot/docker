#!/usr/bin/env bash
# ---
# Docker BuildX Helper script for building docker images.
# ---

set -eu;

cat <<-'EOF'
                     _            _____
     /\             | |     /\   |_   _|
    /  \    ______ _| |_   /  \    | |
   / /\ \  |_  / _` | __| / /\ \   | |
  / ____ \  / / (_| | |_ / ____ \ _| |_
 /_/    \_\/___\__,_|\__/_/    \_\_____|
            @azataiot - 2024

EOF

# ---
# Utility script to get the version from the Dockerfile
# ---
# Usage: get_version [path]

PWD=$(dirname "$0")
# If no path provided, show help
if [ $# -eq 0 ]; then
    cat <<-'EOF'
    Usage: buildx [path] [options]

    Options:
    - `--registry` choose the registry to push the image to, default is `docker.io`
    - `--no-latest` do not tag the image as `latest`, default is `false`
    - `-f` specify the variant of the Dockerfile to use (e.g. `-f alpine`)
EOF
    exit 1;
fi

# First argument is the path to the Dockerfile inside the Containers directory.
CONTAINERS_DIR="$PWD/../Containers"
IMAGE_DIR="$CONTAINERS_DIR/$1"
IMAGE_NAME="azataiot/$1"

# DEFAULTS
DOCKERFILE_PATH="$IMAGE_DIR/Dockerfile"
HAS_VARIANT=false
REGISTRY="docker.io"
LATEST=true

# If the Dockerfile does not exist, show an error message and exit.
if [ ! -f "$DOCKERFILE_PATH" ]; then
    echo "Dockerfile not found at $DOCKERFILE_PATH"
    exit 1;
fi
shift 1;

while [ $# -gt 0 ]; do
    case "$1" in
        --registry)
            REGISTRY="$2"
            shift 2
            ;;
        -f)
            VARIANT="$2"
            HAS_VARIANT=true
            DOCKERFILE_PATH="$IMAGE_DIR/Dockerfile-$VARIANT"
            if [ ! -f "$DOCKERFILE_PATH" ]; then
              echo "Dockerfile not found at $DOCKERFILE_PATH"
              exit 1;
            fi
            shift 2
            ;;
        --no-latest)
            LATEST=false
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1;
            ;;
    esac
done


# Get the version from the Dockerfile
VERSION=$(sed -n 's/ARG VERSION=\(.*\)/\1/p' "$DOCKERFILE_PATH")

if [ -z "$VERSION" ]; then
    echo "Version not found in the Dockerfile"
    exit 1;
fi

# In case we have a variant, we need to append it to the version
if [ "$HAS_VARIANT" = true ]; then
    VERSION="$VERSION-$VARIANT"
fi
# Build the image

# Dynamically create the buildx build command
CMD="docker buildx build --platform linux/amd64,linux/arm64 -t $REGISTRY/$IMAGE_NAME:$VERSION"
if [ "$HAS_VARIANT" = true ]; then
    CMD="$CMD -f $DOCKERFILE_PATH"
fi
# if the latest flag is set to true, tag the image as latest
if [ "$LATEST" = true ]; then
    CMD="$CMD -t $REGISTRY/$IMAGE_NAME:latest"
fi

# Show info about the build
echo "Building $REGISTRY/$IMAGE_NAME:$VERSION (latest: $LATEST)"

CMD="$CMD --push $IMAGE_DIR"

# Run the build command
eval "$CMD"
