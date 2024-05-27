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

if [ "$1" != "jobctl" ]; then
  echo "No arguments provided; Running the command..."
  exec "$@"
fi

# Turn on bash's job control
set -m

# Start the primary process and put it in the background
for i in {1..10}; do
  echo "Primary process is running... $i"
  sleep 1
done

# Wait for the primary process to start
sleep 1

# Start the helper process

for i in {1..3}; do
  echo "Helper process is running... $i"
  sleep 1
done

# Bring the primary process back into the foreground
fg %1
