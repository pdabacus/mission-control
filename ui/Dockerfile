#
# @file ui/Dockerfile
# @author Pavan Dayal
#

# base
ARG BASE_IMG
FROM $BASE_IMG

# args
ARG UI
ENV UI $UI

ARG VERSION
ENV VERSION $VERSION

ARG DEFAULT_PORT
ENV DEFAULT_PORT $DEFAULT_PORT

# label
LABEL \
    Maintainer="admin@liquidrocketry.com" \
    Name="$UI" \
    Version="$VERSION"

# dependencies
USER root
RUN pacman -Sy --noconfirm make python gettext

# build
WORKDIR /app
COPY /${UI}/src/ /app/src/
COPY /${UI}/test/ /app/test/
COPY /${UI}/test_fn/ /app/test_fn/
COPY /${UI}/Makefile /app/Makefile

# run
EXPOSE $DEFAULT_PORT
CMD ["node", "/app/src/index.js"]
