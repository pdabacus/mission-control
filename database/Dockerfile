#
# @file database/Dockerfile
# @author Pavan Dayal
#

# base
ARG BASE_IMG
FROM $BASE_IMG

# args
ARG DATABASE
ENV DATABASE $DATABASE

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
RUN pacman -Sy --noconfirm make python gettext \
    python-setuptools python-coverage python-flask

# build
WORKDIR /app
COPY /${DATABASE}/src/ /app/src/
COPY /${DATABASE}/test/ /app/test/
COPY /${DATABASE}/test_fn/ /app/test_fn/
COPY /${DATABASE}/Makefile /app/Makefile

# run
EXPOSE $DEFAULT_PORT
CMD ["python3", "/app/src/database.py"]
