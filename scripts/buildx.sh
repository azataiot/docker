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


PWD=$(dirname "$0")
# If no path provided, show help
if [ $# -eq 0 ]; then
    cat <<-'EOF'
    Usage: buildx [path] [options]

    Options:
    - `--registry` choose the registry to push the image to, default is `docker.io`
    - `--no-latest` do not tag the image as `latest`, default is `false`
EOF
    exit 1;
fi

# First argument is the path to the Dockerfile inside the Containers directory.
CONTAINERS_DIR="$PWD/../Containers"
IMAGE_DIR="$CONTAINERS_DIR/$1"
IMAGE_NAME="azataiot/$1"
DOCKERFILE_PATH="$IMAGE_DIR/Dockerfile"
VERSION_FILE_PATH="$IMAGE_DIR/.version"

# If the Dockerfile does not exist, show an error message and exit.
if [ ! -f "$DOCKERFILE_PATH" ]; then
    echo "Dockerfile not found at $DOCKERFILE_PATH"
    exit 1;
fi

# If the version file does not exist, show an error message and exit.
if [ ! -f "$VERSION_FILE_PATH" ]; then
    echo "Version file not found at $VERSION_FILE_PATH"
    exit 1;
fi

# Read the version from the version file.
VERSION=$(cat "$VERSION_FILE_PATH")

shift 1;

# check if the registry is provided
REGISTRY="docker.io"
LATEST=true

while [ $# -gt 0 ]; do
    case "$1" in
        --registry)
            REGISTRY="$2"
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

# Show info about the build
echo "Building $REGISTRY/$IMAGE_NAME:$VERSION (latest: $LATEST)"

# Build the image

# Dynamically create the buildx build command
CMD="docker buildx build --platform linux/amd64,linux/arm64 -t $REGISTRY/$IMAGE_NAME:$VERSION"
# if the latest flag is set to true, tag the image as latest
if [ "$LATEST" = true ]; then
    CMD="$CMD -t $REGISTRY/$IMAGE_NAME:latest"
fi
CMD="$CMD --push $IMAGE_DIR"

# Run the build command
eval "$CMD"
