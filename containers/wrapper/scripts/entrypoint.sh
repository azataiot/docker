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

if [ "$1" != "wrapper" ]; then
  echo "No arguments provided; Running the command..."
  exec "$@"
fi

echo "Starting the Wrapper..."

# Start the first process

for i in {1..10}; do
  echo "1st process is running... $i"
  sleep 1
done

# Start the second process
for i in {1..11}; do
  echo "2nd process is running... $i"
  sleep 1
done

# Wait for any process to exit
wait -n
echo "All processes are done. Exiting..."

# Exit with status of process that exited first
exit $?