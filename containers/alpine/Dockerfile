# -----------------------
# Alpine Linux Base Image
# https://www.alpinelinux.org/
# Author: @azataiot
# Date: 2024-05-13
# ----------------

# Why this iamge ?
# Features:
# - Added nano editor
# - Added bash shell and made it the default shell

# Usage:
# docker run -it --rm azataiot/alpine

ARG BASE_IMAGE=alpine:3.19
FROM ${BASE_IMAGE} as builder
ENV LANG en_US.utf8
RUN set -eux; \
	\
	apk update; \
    apk upgrade; \
    apk add --no-cache \
        readline \
        ncurses \
        bash \
        su-exec \
        nano

FROM ${BASE_IMAGE} as final
COPY --from=builder /bin/bash /bin/bash
COPY --from=builder /sbin/su-exec /sbin/su-exec
COPY --from=builder /usr/bin/nano /usr/bin/nano
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /usr/lib/libreadline.so.8 /usr/lib/libreadline.so.8
COPY --from=builder /usr/lib/libncursesw.so.6 /usr/lib/libncursesw.so.6

# Copy the docker-entrypoint.sh script into the Docker image
COPY ./scripts/entrypoint.sh /usr/local/bin/

# Make the script executable
RUN chmod +x /usr/local/bin/entrypoint.sh

# Use the script as the entrypoint
ENTRYPOINT ["entrypoint.sh"]
CMD ["bash"]