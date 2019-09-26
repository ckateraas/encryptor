#! /usr/bin/env bash

set -e

PATH_TO_ENCRYPT=$(basename "$1")

if [[ ! -f "$PATH_TO_ENCRYPT" && ! -d "$PATH_TO_ENCRYPT" ]]; then
    echo "No such file or directory, $PATH_TO_ENCRYPT"
    exit 1
fi

if ! docker image ls | grep -q encryptor; then
  echo "No image for encryptor found - building it..."
  docker build -t encryptor . &> /dev/null
  echo "... Docker image built!"
fi

INTERMEDIATE_ARCHIVE_NAME="$PATH_TO_ENCRYPT-$( date +'%F-%R' )"
DOCKER_CMD=( docker run --rm -it -v "$(pwd)":/encryptor encryptor )

"${DOCKER_CMD[@]}" tar czf "$INTERMEDIATE_ARCHIVE_NAME" "$PATH_TO_ENCRYPT"
"${DOCKER_CMD[@]}" gpg --symmetric "$INTERMEDIATE_ARCHIVE_NAME"
"${DOCKER_CMD[@]}" rm "$INTERMEDIATE_ARCHIVE_NAME"
"${DOCKER_CMD[@]}" chown "${UID}:${GUID}" "$INTERMEDIATE_ARCHIVE_NAME".gpg

echo "Completed encryption. Created archive is $INTERMEDIATE_ARCHIVE_NAME.gpg"
echo
echo "Delete the encrypted file, $PATH_TO_ENCRYPT? [y/N]"
read -s -r -n 1
case "$REPLY" in
        y|Y )
            echo "Ok! Deleting $PATH_TO_ENCRYPT"
            "${DOCKER_CMD[@]}" rm -rf "$PATH_TO_ENCRYPT"
            ;;
        * )
            echo "Ok! Not deleting. Bye!"
            ;;
esac
