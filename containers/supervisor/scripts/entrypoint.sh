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

if [ "$1" != "supervisor" ]; then
  echo "No arguments provided; Running the command..."
  exec "$@"
fi

echo "Starting Supervisor..."
supervisord -c /etc/supervisord.conf

echo "Loading Supervisor configuration files..."
supervisorctl reread
supervisorctl update

echo "Starting Supervisor services..."
supervisorctl start all

echo "Supervisor is running..."


