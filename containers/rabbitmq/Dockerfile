# -----------------------
# RabbitMQ Dockerfile
# https://www.rabbitmq.com/docs
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
        erlang

# Download "Generic Binary Build" of RabbitMQ server
RUN set -eux; \
    \
    wget https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.13.2/rabbitmq-server-generic-unix-3.13.2.tar.xz; \
    tar -xf rabbitmq-server-generic-unix-3.13.2.tar.xz; \
    mv rabbitmq_server-3.13.2 /opt/rabbitmq; \
    ls -la /opt/rabbitmq; \
    rm rabbitmq-server-generic-unix-3.13.2.tar.xz; \
    echo 'export PATH=/opt/rabbitmq/sbin:$PATH' >> ~/.bashrc ; \
    echo "loopback_users.guest = false" >> /opt/rabbitmq/etc/rabbitmq/rabbitmq.conf; \
    echo "log.console = true" >> /opt/rabbitmq/etc/rabbitmq/rabbitmq.conf


FROM ${BASE_IMAGE} as final

ENV LANG en_US.utf8
ENV RABBITMQ_ENABLE_MANAGEMENT_UI=true

RUN set -eux; \
	\
	apk add --no-cache \
        erlang

COPY --from=builder /root/.bashrc /root/.bashrc
COPY --from=builder /opt/rabbitmq/escript /opt/rabbitmq/escript
COPY --from=builder /opt/rabbitmq/etc /opt/rabbitmq/etc
COPY --from=builder /opt/rabbitmq/plugins /opt/rabbitmq/plugins
COPY --from=builder /opt/rabbitmq/sbin /opt/rabbitmq/sbin
COPY --from=builder /opt/rabbitmq/share /opt/rabbitmq/share

EXPOSE 5672 15672
VOLUME /opt/rabbitmq/var

# Copy the docker-entrypoint.sh script into the Docker image
COPY ./scripts/entrypoint.sh /usr/local/bin/

# Make the script executable
RUN chmod +x /usr/local/bin/entrypoint.sh

# Use the script as the entrypoint
ENTRYPOINT ["entrypoint.sh"]
CMD ["rabbitmq"]
