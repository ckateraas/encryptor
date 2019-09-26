# Encryptor

Use Docker and GPG to encrypt and decrypt files on your machine.

## Encrypting

If you want to archive a folder, or a single file, you can use `encrypt.sh`.
This script will also check if you have the _encryptor_ Docker image locally and build the image
if it is missing.

```sh
# A single file
./encrypt.sh my-secret-file.txt

# Or a directory
./encrypt.sh my-secret-journal/
```

After running `encrypt.sh` you will be prompted by `gpg` for a password.
Once you have filled in your password, you will find a `.gpg` file in your current directory.
This file is an encrypted tar archive of the file/directory you specified.

## Decrypting

To restore the contents of an encrypted archive, use `decrypt.sh`.

```sh
./decrypt.sh my-secret-archive.gpg
```
