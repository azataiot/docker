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

# Utility functions
# -----------------

# Set default environment variable if not set and export it
# usage: set_default_env "VAR" "default_value"
set_default_env() {
    local var="$1"
    local default_value="$2"

    if [ -z "${!var}" ]; then
        export "$var"="$default_value"
    fi
}

create_folders() {
    mkdir -p /var/lib/mailpit/data
}

# Create a Mailpit password file for authentication
# https://mailpit.axllent.org/docs/configuration/passwords/
# usage: create_password_file "user" "password" "file"
create_password_file() {
    local user="$1"
    local password="$2"
    local file="$3"

    echo "$user:$password" > "$file"
    chmod 600 "$file"
}


# Check the first argument, if it's not `postgres` then run the argument as a command
if [ "$1" != 'mailpit' ]; then
  echo "No arguments provided; Running the command..."
  exec "$@"
fi

# Create the Mailpit password file
set_default_env "MAILPIT_USER" "mailpit"
set_default_env "MAILPIT_PASSWORD" "mailpit"
create_password_file "$MAILPIT_USER" "$MAILPIT_PASSWORD" "/tmp/mpauth"

# Set default environment variables
# ---------------------------------
set_default_env "MP_UI_AUTH_FILE" "/tmp/mpauth"
set_default_env "MP_DATABASE" "/var/lib/mailpit/data/mailpit.db"

echo "Starting the Mailpit service..."
mailpit

