#! /usr/bin/env bash

set -e

ARCHIVE_NAME=$1

if [[ ! -f "$ARCHIVE_NAME" ]]; then
    echo "Could not find the encrypted archive, $ARCHIVE_NAME"
    exit 1
fi

DOCKER_CMD=( docker run --rm -it -v "$(pwd)":/encryptor encryptor )

"${DOCKER_CMD[@]}" gpg --output intermediate-archive.tar.gz --decrypt "$ARCHIVE_NAME"
"${DOCKER_CMD[@]}" tar xzf intermediate-archive.tar.gz
"${DOCKER_CMD[@]}" rm intermediate-archive.tar.gz
# "${DOCKER_CMD[@]}" chown -R "${UID}:${GUID}" /encryptor
