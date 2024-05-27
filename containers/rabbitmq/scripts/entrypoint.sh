#!/usr/bin/env bash
# -------------------------
# Docker Entrypoint script.
# Author: @azataiot
# Last update: 2024-05-13
# -----------------------
cat <<-'EOF'
                     _            _____
     /\             | |     /\   |_   _|
    /  \    ______ _| |_   /  \    | |
   / /\ \  |_  / _` | __| / /\ \   | |
  / ____ \  / / (_| | |_ / ____ \ _| |_
 /_/    \_\/___\__,_|\__/_/    \_\_____|
            @azataiot - 2024

EOF

# Set default environment variable if not set and export it
# usage: set_default_env "VAR" "default_value"
set_default_env() {
    local var="$1"
    local default_value="$2"

    if [ -z "${!var}" ]; then
        export "$var"="$default_value"
    fi
}

# Set default environment variables
set_default_env "RABBITMQ_USER" "admin"
set_default_env "RABBITMQ_PASSWORD" "admin"
set_default_env "RABBITMQ_ENABLE_MANAGEMENT_UI" "true"

if [ "$1" != 'rabbitmq' ]; then
  echo "No arguments provided; Running the command..."
  exec "$@"
fi

# Source the bash profile to load the RabbitMQ environment variables
source /root/.bashrc

# Start the RabbitMQ server
echo "Starting RabbitMQ server..."
set -m
rabbitmq-server &

# Enable RabbitMQ Management UI
if [ "$RABBITMQ_ENABLE_MANAGEMENT_UI" = "true" ]; then
  echo "Enabling RabbitMQ Management UI..."
  rabbitmq-plugins enable rabbitmq_management
fi

# Bring the RabbitMQ server process back to the foreground
fg %1

