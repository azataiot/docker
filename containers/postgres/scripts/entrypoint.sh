#!/usr/bin/env bash
# -------------------------
# Docker Entrypoint script.
# Author: @azataiot
# Last update: 2024-05-17
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

# Utility functions
# -----------------

# Create the PostgreSQL user [✅]
# https://www.postgresql.org/docs/current/app-createuser.html


# Create the PostgreSQL cluster
# https://www.postgresql.org/docs/current/creating-cluster.html#CREATING-CLUSTER
pg_create_cluster() {
  echo "Setting up PostgreSQL database cluster..."
  echo "PGDATA: $PGDATA"
  # Initialize the PostgreSQL database
  su-exec postgres initdb --auth-host=scram-sha-256 --encoding=UTF8 --user="$POSTGRES_USER" --pwfile=/tmp/pgpass -D "$PGDATA"
  # Remove the password file
  rm /tmp/pgpass
}

pg_configure_cluster() {
  echo "Configuring PostgreSQL database cluster..."
  su-exec postgres sed -ri 's!^#?(listen_addresses)\s*=\s*\S+.*!\1 = '\''*'\''!' "$PGDATA"/postgresql.conf
  su-exec postgres grep -q -F "host all all all scram-sha-256" "$PGDATA"/pg_hba.conf || su-exec postgres echo "host all all all scram-sha-256" >> "$PGDATA"/pg_hba.conf
}

# If the user has provided a different database name than the default `postgres`, create the database
pg_create_db() {
  if [ "$POSTGRES_DB" != 'postgres' ]; then
    echo "Creating PostgreSQL database: $POSTGRES_DB ..."
    # Create the PostgreSQL database
    echo "CREATE DATABASE $POSTGRES_DB;" | psql -b --username="$POSTGRES_USER" --no-password --no-psqlrc
  fi
}

# Process the command line arguments
# ----------------------------------

# Check the first argument, if it's not `postgres` then run the argument as a command
if [ "$1" != 'postgres' ]; then
  echo "No arguments provided; Running the command..."
  exec "$@"
fi

# Check if the data directory is empty
if [ ! -s "$(ls -A "$PGDATA")" ]; then
  # Initialize the PostgreSQL database
  pg_create_cluster
  # Configure the PostgreSQL database cluster
  pg_configure_cluster

else
  echo "PostgreSQL Database directory appears to contain a database; Skipping initialization..."
fi

# Check if the PostgreSQL service is running
if [ ! -f /var/lib/postgresql/data/postmaster.pid ]; then
  # Start the PostgreSQL service
  echo "Starting the PostgreSQL service..."
  # Bash job control
  # https://docs.docker.com/config/containers/multi-service_container/
  set -m
  su-exec postgres postgres -D "$PGDATA" &
  # Wait for the PostgreSQL service to start
  until su-exec postgres pg_isready; do
    echo "Waiting for the PostgreSQL service to start..."
    sleep 1
  done
  # Create the PostgreSQL database if it doesn't exist (default: `postgres`)
  pg_create_db
  # Bash job control
  fg %1
fi
