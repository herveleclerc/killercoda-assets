FROM alpine:latest

RUN apk add --no-cache \
  openssl \
  jq      \
  curl    \
  websocat
