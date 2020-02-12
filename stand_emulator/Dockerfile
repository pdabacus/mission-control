#
# @file stand_emulator/Dockerfile
# @author Pavan Dayal
#

# base
ARG BASE_IMG
FROM $BASE_IMG

# args
ARG STAND_EMU
ENV STAND_EMU $STAND_EMU

ARG VERSION
ENV VERSION $VERSION

ARG DEFAULT_PORT
ENV DEFAULT_PORT $DEFAULT_PORT

# label
LABEL \
    Maintainer="admin@liquidrocketry.com" \
    Name="$STAND_EMU" \
    Version="$VERSION"

# dependencies
USER root
RUN pacman -Sy --noconfirm gcc make python gettext

# build
WORKDIR /app
COPY /${STAND_EMU}/src/ /app/src/
COPY /${STAND_EMU}/test/ /app/test/
COPY /${STAND_EMU}/test_fn/ /app/test_fn/
COPY /${STAND_EMU}/Makefile /app/Makefile
RUN make FLAGS="-D VERSION=\\\"\${VERSION}\\\" -D DEFAULT_PORT=\${DEFAULT_PORT}"

# run
EXPOSE $DEFAULT_PORT
CMD ["/app/a.out"]
