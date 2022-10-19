#!/bin/bash

set -ex

# Since all the dockerfiles now require buildkit features.
export DOCKER_BUILDKIT=1

# Set the default value of BUILD_ROLLING to no.
export BUILD_ROLLING="${1:-no}"

DOCKER=docker

if [ "$BUILD_ROLLING" = "yes" ]; then
    echo "Building rolling releases..."
    # Build the mailman-core image.
    $DOCKER build -f core/Dockerfile.dev \
            --label version.git_commit="$COMMIT_ID" \
            -t darrenopf/mailman-core:0.0.2 core/

    # Build the mailman-web image.
    $DOCKER build -f web/Dockerfile.dev \
            --label version.git_commit="$COMMIT_ID" \
            -t darrenopf/mailman-web:0.0.2 web/

    # build the postorius image.
    $DOCKER build -f postorius/Dockerfile.dev\
			--label version.git_commit="$COMMIT_ID"\
			-t darrenopf/postorius:0.0.2 postorius/
else
    echo "Building stable releases..."
    # Build the stable releases.
    $DOCKER build -t darrenopf/mailman-core:0.0.2 core/
    $DOCKER build -t darrenopf/mailman-web:0.0.2 web/
    $DOCKER build -t darrenopf/postorius:0.0.2 postorius/
fi
