# -----------------------
# Postgres Dockerfile
# Author: @azataiot
# Date: 2024-05-13
# ----------------

FROM azataiot/alpine:latest
RUN set -eux; \
    apk add --no-cache \
        postgresql \
        postgresql-contrib

# This will install the postgresql packages and creates the postgres user.
# The postgres user is the default superuser for the postgres database.
# https://www.postgresql.org/docs/16/postgres-user.html

ENV PGDATA=/var/lib/postgresql/data
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres
ENV POSTGRES_DB=postgres
ENV TZ=UTC

RUN set -eux; \
      \
        mkdir -p /run/postgresql && chown -R postgres:postgres /run/postgresql && chmod 3777 /var/run/postgresql ; \
        echo "$POSTGRES_PASSWORD" > /tmp/pgpass


EXPOSE 5432
VOLUME /var/lib/postgresql/data

# Copy the docker-entrypoint.sh script into the Docker image
COPY ./scripts/entrypoint.sh /usr/local/bin/

# Make the script executable
RUN chmod +x /usr/local/bin/entrypoint.sh

# Use the script as the entrypoint
ENTRYPOINT ["entrypoint.sh"]
CMD ["postgres"]



