# -----------------------
# Docker Multi-Service Bash Job Control Example
# https://docs.docker.com/config/containers/multi-service_container/#use-bash-job-controls
# Author: @azataiot
# Date: 2024-05-27
# ----------------

ARG BASE_IMAGE=azataiot/alpine:latest
FROM ${BASE_IMAGE} as builder
ENV LANG en_US.utf8

# Copy the docker-entrypoint.sh script into the Docker image
COPY ./scripts/entrypoint.sh /usr/local/bin/

# Make the script executable
RUN chmod +x /usr/local/bin/entrypoint.sh

# Use the script as the entrypoint
ENTRYPOINT ["entrypoint.sh"]
CMD ["jobctl"]
