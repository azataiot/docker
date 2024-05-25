# -----------------------
# Alpine Linux Base Image
# https://www.alpinelinux.org/
# Author: @azataiot
# Date: 2024-05-13
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
        su-exec \
        nano

# Change the defult shell to bash
RUN sed -i -e '/^root:/ s|/bin/ash|/bin/bash|' /etc/passwd

FROM ${BASE_IMAGE} as final
# COPY bash dependencies from the builder
# bash AND nano both depend on : /usr/lib/libreadline.so.8 and /usr/lib/libncursesw.so.6
COPY --from=builder /usr/lib/libreadline.so.8 /usr/lib/libreadline.so.8
COPY --from=builder /usr/lib/libncursesw.so.6 /usr/lib/libncursesw.so.6
# COPY bash binary from the builder
COPY --from=builder /bin/bash /bin/bash
# COPY bashrc from the builder
COPY --from=builder /etc/bash/bashrc /etc/bash/bashrc
# COPY su-exec binary from the builder
COPY --from=builder /sbin/su-exec /sbin/su-exec
COPY --from=builder /usr/bin/nano /usr/bin/nano
# COPY passwd from the builder (which changed the default shell to bash)
COPY --from=builder /etc/passwd /etc/passwd


VOLUME /etc/bash

# Copy the docker-entrypoint.sh script into the Docker image
COPY ./scripts/entrypoint.sh /usr/local/bin/

# Make the script executable
RUN chmod +x /usr/local/bin/entrypoint.sh

# Use the script as the entrypoint
ENTRYPOINT ["entrypoint.sh"]
CMD ["bash"]
