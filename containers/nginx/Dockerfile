# -----------------------
# Nginx Dockerfile
# https://nginx.org/en/docs/
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
        nginx

EXPOSE 80
VOLUME /etc/nginx/http.d/
VOLUME /etc/nginx/conf.d/
VOLUME /usr/share/nginx/html/

# Copy the nginx configuration file into the Docker image
COPY conf.d/ /etc/nginx/conf.d/
COPY http.d/ /etc/nginx/http.d/
COPY html/ /usr/share/nginx/html/

# Copy the docker-entrypoint.sh script into the Docker image
COPY ./scripts/entrypoint.sh /usr/local/bin/

# Make the script executable
RUN chmod +x /usr/local/bin/entrypoint.sh

# Use the script as the entrypoint
ENTRYPOINT ["entrypoint.sh"]
CMD ["nginx"]
