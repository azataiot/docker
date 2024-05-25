# -----------------------
# Mailpit Dockerfile
# https://mailpit.axllent.org/
# Author: @azataiot
# Date: 2024-05-13
# ----------------
ARG BASE_IMAGE=azataiot/alpine:latest
FROM ${BASE_IMAGE} as builder
ENV LANG en_US.utf8

RUN set -eux; \
    apk update; \
    apk upgrade; \
    apk add --no-cache \
        curl; \
    MP_VERSION=$(curl --silent --location --max-time "90" "https://api.github.com/repos/axllent/mailpit/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'); \
    BUILDOS=$(uname -s | tr '[:upper:]' '[:lower:]'); \
    BUILDARCH=$(uname -m); \
    if [ "$BUILDARCH" = "aarch64" ]; then \
        BUILDARCH="arm64"; \
    elif [ "$BUILDARCH" = "x86_64" ]; then \
        BUILDARCH="amd64"; \
    fi; \
    MP_GO_BIN="mailpit-${BUILDOS}-${BUILDARCH}.tar.gz"; \
    echo "Downloading Mailpit ${MP_VERSION} for ${BUILDOS}-${BUILDARCH}"; \
    mkdir -p /tmp/mailpit; \
    wget -O /tmp/mailpit/${MP_GO_BIN} https://github.com/axllent/mailpit/releases/download/${MP_VERSION}/${MP_GO_BIN}; \
    tar -xzf /tmp/mailpit/${MP_GO_BIN} -C /tmp/mailpit; \
    mv /tmp/mailpit/mailpit /usr/local/bin/mailpit; \
    chmod +x /usr/local/bin/mailpit; \
    rm -rf /tmp/mailpit

FROM ${BASE_IMAGE} as final

ENV MAILPIT_USER=mailpit
ENV MAILPIT_PASSWORD=mailpit

COPY --from=builder /usr/local/bin/mailpit /usr/local/bin/mailpit
EXPOSE 8025
EXPOSE 1025
VOLUME /var/lib/mailpit/data

# Copy the docker-entrypoint.sh script into the Docker image
COPY ./scripts/entrypoint.sh /usr/local/bin/

# Make the script executable
RUN chmod +x /usr/local/bin/entrypoint.sh

# Use the script as the entrypoint
ENTRYPOINT ["entrypoint.sh"]
CMD ["mailpit"]