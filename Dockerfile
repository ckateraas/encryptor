FROM alpine:latest

RUN apk update
RUN apk upgrade
RUN apk add --update gnupg

WORKDIR /encryptor
