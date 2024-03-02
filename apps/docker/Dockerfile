ARG UBUNTU_VERSION=20.04 # lts

FROM linuxserver/openssh-server as acore-ssh

ARG MYSQL_USER
ARG MYSQL_PASSWORD
ARG MYSQL_HOST
ARG MYSQL_PORT

ENV TZ=Etc/UTC
ENV PUID=1000
ENV PGID=1000
ENV LISTEN_PORT=22
ENV USER_NAME=acore
ENV MYSQL_USER=acore
ENV MYSQL_PASSWORD=acore
ENV MYSQL_HOST=172.23.48.15

RUN apk add rsync git mysql-client mariadb-connector-c-dev
RUN echo -e "[client]\nuser=${MYSQL_USER}\npassword=${MYSQL_PASSWORD}\nhost=${MYSQL_PASSWORD}\nport=${MYSQL_PORT}" > /config/.my.cnf
RUN mkdir -pv \
        /custom-cont-init.d     \
        /azerothcore/backups    \
        /azerothcore/data       \
        /azerothcore/source     \
        /azerothcore/logs     \
        /azerothcore/etc
RUN echo -e "#!/bin/bash\nchown -R ${PUID}:${PGID} /azerothcore" > /custom-cont-init.d/volume-permissions.sh
RUN chmod u+x /custom-cont-init.d/*
RUN git clone https://github.com/jasonschulte/azerothcore-config.git /azerothcore/etc

VOLUME /azerothcore/backups
VOLUME /azerothcore/data
VOLUME /azerothcore/source
VOLUME /azerothcore/logs
VOLUME /azerothcore/etc

WORKDIR /azerothcore

## Setup base ubuntu image for world and auth servers

FROM ubuntu:$UBUNTU_VERSION as acore-runtime

ARG DOCKER=1
ARG DEBIAN_FRONTEND=noninteractive
ARG MYSQL_USER
ARG MYSQL_PASSWORD
ARG MYSQL_HOST
ARG MYSQL_PORT="3306"
ARG ACORE_AUTH_DATABASE="acore_auth"
ARG ACORE_WORLD_DATABASE="acore_world"
ARG ACORE_CHARACTER_DATABASE="acore_characters"

ENV TZ=Etc/UTC
ENV USER_ID=1000
ENV GROUP_ID=1000
ENV USER_NAME=acore
ENV ACORE_COMPONENT=undefined
ENV AC_LOGIN_DATABASE_INFO="${MYSQL_HOST};${MYSQL_PORT};${MYSQL_USER};${MYSQL_PASSWORD};${ACORE_AUTH_DATABASE}"
ENV AC_WORLD_DATABASE_INFO="${MYSQL_HOST};${MYSQL_PORT};${MYSQL_USER};${MYSQL_PASSWORD};${ACORE_WORLD_DATABASE}"
ENV AC_CHARACTER_DATABASE_INFO="${MYSQL_HOST};${MYSQL_PORT};${MYSQL_USER};${MYSQL_PASSWORD};${ACORE_CHARACTER_DATABASE}"
ENV AC_SOURCE_DIRECTORY="/azerothcore/source"

# Configure Timezone
# RUN apt-get update                                          \
#     && apt-get install -y tzdata ca-certificates            \
#     && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime   \
#     && echo $TZ > /etc/timezone                         \
#     && dpkg-reconfigure --frontend noninteractive tzdata

# Install base dependencies for azerothcore
RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      tzdata ca-certificates \
      libmysqlclient21 libreadline8 \
      libboost-system1.71.0 libboost-filesystem1.71.0 \
      libboost-program-options1.71.0 libboost-iostreams1.71.0 \
      libboost-regex1.71.0 \
      gettext-base default-mysql-client && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -pv \
        /azerothcore/backups    \
        /azerothcore/data       \
        /azerothcore/source     \
        /azerothcore/logs     \
        /azerothcore/etc \
        /azerothcore/tmp \
        /azerothcore/bin

VOLUME /azerothcore/backups
VOLUME /azerothcore/data
VOLUME /azerothcore/source
VOLUME /azerothcore/logs
VOLUME /azerothcore/etc

ENV PATH="/azerothcore/bin:$PATH"

RUN groupadd --gid "$GROUP_ID"  "$USER_NAME" && \
    useradd -d /azerothcore --uid "$USER_ID"  --gid "$GROUP_ID"  "$USER_NAME" && \
    chown -R "$USER_NAME:$USER_NAME" /azerothcore && \
    passwd -d "$USER_NAME"

COPY --chown=$USER_ID:$GROUP_ID \
     --chmod=755 \
     entrypoint.sh /azerothcore/entrypoint.sh

WORKDIR /azerothcore/bin

USER $USER_NAME

ENTRYPOINT ["/usr/bin/env", "bash", "/azerothcore/entrypoint.sh"]

###############
# Auth Server #
###############

FROM acore-runtime as acore-auth
LABEL description "AzerothCore Auth Server"

ENV ACORE_COMPONENT=authserver
# Don't run database migrations. We can leave that up to the db-import container
#ENV AC_UPDATES_ENABLE_DATABASES=0
# This disables user prompts. The console is still active, however
ENV AC_DISABLE_INTERACTIVE=1
#ENV AC_CLOSE_IDLE_CONNECTIONS=0

COPY --chown=$USER_NAME:$USER_NAME \
    bin/authserver /azerothcore/bin/authserver

CMD ["authserver"]

###############
# World Server #
###############

FROM acore-runtime as acore-world
LABEL description "AzerothCore World Server"

ENV ACORE_COMPONENT=worldserver
# Don't run database migrations. We can leave that up to the db-import container
#ENV AC_UPDATES_ENABLE_DATABASES=0
# This disables user prompts. The console is still active, however
ENV AC_DISABLE_INTERACTIVE=1
#ENV AC_CLOSE_IDLE_CONNECTIONS=0

COPY --chown=$USER_NAME:$USER_NAME \
    bin/worldserver /azerothcore/bin/worldserver

# CMD ["tail", "-f", "/dev/null"]
CMD ["worldserver"]