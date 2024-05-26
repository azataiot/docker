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

if [ "$1" != 'nginx' ]; then
  echo "No arguments provided; Running the command..."
  exec "$@"
fi

nginx -g "daemon off;"