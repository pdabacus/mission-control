#
# @file database/Dockerfile
# @author Pavan Dayal
#

# base
ARG BASE_IMG
FROM $BASE_IMG

# args
ARG VERSION
ENV VERSION $VERSION

ARG DEFAULT_PORT
ENV DEFAULT_PORT $DEFAULT_PORT

# label
LABEL \
    Maintainer="admin@liquidrocketry.com" \
    Name="$DATABASE" \
    Version="$VERSION"

# dependencies
USER root
RUN pacman -Sy --noconfirm make python gettext jq \
    python-setuptools python-coverage python-flask

# build
WORKDIR /app
COPY /src/ /app/src/
COPY /res/ /app/res/
COPY /test/ /app/test/
COPY /test_fn/ /app/test_fn/
COPY /Makefile /app/Makefile
COPY /settings.json /app/settings.json

# run
EXPOSE $DEFAULT_PORT
CMD ["make", "run"]
