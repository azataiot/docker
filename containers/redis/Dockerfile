# -----------------------
# Docker Container Template
# https://www.alpinelinux.org/
# Author: @azataiot
# Date: 2024-05-25
# ----------------

ARG BASE_IMAGE=azataiot/alpine:latest
FROM ${BASE_IMAGE} as builder
ENV LANG en_US.utf8

RUN set -eux; \
	\
	apk update; \
    apk upgrade; \
    apk add --no-cache \
        redis

ENV REDIS_PASSWORD=redis
EXPOSE 6379
VOLUME /etc/redis/

# Copy the docker-entrypoint.sh script into the Docker image
COPY ./scripts/entrypoint.sh /usr/local/bin/

# Make the script executable
RUN chmod +x /usr/local/bin/entrypoint.sh

# Use the script as the entrypoint
ENTRYPOINT ["entrypoint.sh"]
CMD ["redis"]
