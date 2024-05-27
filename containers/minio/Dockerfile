# -----------------------
# Minio Dockerfile
# https://min.io/docs/minio/linux/index.html
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
        minio

ENV MINIO_ROOT_USER=minio
ENV MINIO_ROOT_PASSWORD=minio123
EXPOSE 9000 9001
VOLUME /var/lib/minio/data

# Copy the docker-entrypoint.sh script into the Docker image
COPY ./scripts/entrypoint.sh /usr/local/bin/

# Make the script executable
RUN chmod +x /usr/local/bin/entrypoint.sh

# Use the script as the entrypoint
ENTRYPOINT ["entrypoint.sh"]
CMD ["minio"]
