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

CMD="redis"

# Set default environment variable if not set and export it
# usage: set_default_env "VAR" "default_value"
set_default_env() {
    local var="$1"
    local default_value="$2"

    if [ -z "${!var}" ]; then
        export "$var"="$default_value"
    fi
}

if [ "$1" != "$CMD" ]; then
  echo "No arguments provided; Running the command..."
  exec "$@"
fi

echo "Starting Redis server..."

mkdir -p /etc/redis
mv /etc/redis.conf /etc/redis/redis.conf

echo "Setting up Redis configuration..."
set_default_env "REDIS_PASSWORD" "redis"
sed -i "s/# requirepass foobared/requirepass $REDIS_PASSWORD/" /etc/redis/redis.conf
sed -i "s/bind 127.0.0.1/bind 0.0.0.0/" /etc/redis/redis.conf
sed -i 's/^daemonize yes/daemonize no/' /etc/redis/redis.conf
sed -i 's/^logfile .*/logfile ""/' /etc/redis/redis.conf

# Start Redis server
echo "Starting Redis server..."
redis-server /etc/redis/redis.conf