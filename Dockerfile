FROM alpine:latest
LABEL MAINTAINER="https://github.com/ryancxeven/Iphish"
WORKDIR Iphish/
ADD . /Iphish
RUN apk add --no-cache bash ncurses curl unzip wget php 
CMD "./Iphish"
