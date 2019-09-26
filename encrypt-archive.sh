#! /usr/bin/env bash

set -e

PATH_TO_ENCRYPT=$(basename "$1")

if ! docker image ls | grep -q encryptor; then
  echo "No image for encryptor found - building it!"
  docker build -t encryptor .
fi

DOCKER_CMD=( docker run --rm -it -v "$(pwd)":/encryptor encryptor )

ENCRYPTED_ARCHIVE_NAME="$PATH_TO_ENCRYPT-$( date +'%F-%R' )"

"${DOCKER_CMD[@]}" tar czf "$ENCRYPTED_ARCHIVE_NAME" "$PATH_TO_ENCRYPT"
"${DOCKER_CMD[@]}" gpg --symmetric "$ENCRYPTED_ARCHIVE_NAME"
"${DOCKER_CMD[@]}" rm "$ENCRYPTED_ARCHIVE_NAME"
"${DOCKER_CMD[@]}" chown "${UID}:${GUID}" "$ENCRYPTED_ARCHIVE_NAME".gpg
# "${DOCKER_CMD[@]}" rm -rf "$PATH_TO_ENCRYPT"
