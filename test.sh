#! /usr/bin/env bash

set -e

FOLDER_TO_ENCRYPT=./test
mkdir -p "$FOLDER_TO_ENCRYPT"
echo "foo" > "$FOLDER_TO_ENCRYPT"/test.file

./encrypt.sh "$FOLDER_TO_ENCRYPT"

rm -rf "$FOLDER_TO_ENCRYPT"
if [[ -d "$FOLDER_TO_ENCRYPT" ]]; then
  echo "Test failed: $FOLDER_TO_ENCRYPT was not deleted"
fi


./decrypt.sh "$(ls -t ./*.gpg | head -n 1)"

FILES_DECRYPTED=$(ls "$FOLDER_TO_ENCRYPT")
if [[ "x$FILES_DECRYPTED" == "xtest.file" ]]; then
  echo "Test passed: $FOLDER_TO_ENCRYPT is identical after decryption"
else
  echo "Test failed: $FOLDER_TO_ENCRYPT is not identical after decryption"
fi

rm -rf "$FOLDER_TO_ENCRYPT"
