# -----------------------
# Supervisor Dockerfile
# http://supervisord.org/
# Author: @azataiot
# Date: 2024-05-27
# ----------------

ARG BASE_IMAGE=azataiot/alpine:latest
FROM ${BASE_IMAGE} as builder
ENV LANG en_US.utf8
RUN set -eux; \
	\
	apk update; \
    apk upgrade; \
    apk add --no-cache \
        supervisor

COPY ./scripts/supervisord.conf /etc/supervisord.conf

VOLUME /etc/supervisor.d/

# Copy the docker-entrypoint.sh script into the Docker image
COPY ./scripts/entrypoint.sh /usr/local/bin/

# Make the script executable
RUN chmod +x /usr/local/bin/entrypoint.sh

# Use the script as the entrypoint
ENTRYPOINT ["entrypoint.sh"]
CMD ["supervisor"]
