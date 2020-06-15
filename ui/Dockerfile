#
# @file ui/Dockerfile
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
    Name="$UI" \
    Version="$VERSION"

# dependencies
USER root
RUN pacman -Sy --noconfirm make python gettext jq \
    nodejs npm git libnghttp2

# build
WORKDIR /app
COPY /src/ /app/src/
COPY /res/ /app/res/
COPY /test/ /app/test/
COPY /test_fn/ /app/test_fn/
COPY /Makefile /app/Makefile
COPY /settings.json /app/settings.json
RUN make build

# run
EXPOSE $DEFAULT_PORT
CMD ["make", "run"]
