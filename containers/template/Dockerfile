# -----------------------
# Docker Container Template
# https://www.alpinelinux.org/
# Author: @azataiot
# Date: 2024-05-25
# ----------------

ARG BASE_IMAGE=alpine:3.19
FROM ${BASE_IMAGE} as builder
ENV LANG en_US.utf8
RUN set -eux; \
	\
	apk update; \
    apk upgrade; \
    apk add --no-cache \
        bash \


FROM ${BASE_IMAGE} as final


EXPOSE 3000
VOLUME /etc/bash

# Copy the docker-entrypoint.sh script into the Docker image
COPY ./scripts/entrypoint.sh /usr/local/bin/

# Make the script executable
RUN chmod +x /usr/local/bin/entrypoint.sh

# Use the script as the entrypoint
ENTRYPOINT ["entrypoint.sh"]
CMD ["bash"]
