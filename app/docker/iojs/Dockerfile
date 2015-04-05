FROM ubuntu:14.04
MAINTAINER Ride Share Market "systemsadmin@ridesharemarket.com"

# APT cache
ENV APT_REFRESHED_AT 2015-04-05.1
RUN apt-get -yqq update

# Install io.js, gpg keys listed at https://github.com/iojs/io.js
ENV IOJS_VERSION 1.5.1
RUN \
    apt-get -y install curl && \
    gpg --keyserver pool.sks-keyservers.net --recv-keys 9554F04D7259F04124DE6B476D5A82AC7E37093B DD8F2338BAE7501E3DD5AC78C273792F7D83545D && \
    curl -SLO "https://iojs.org/dist/v${IOJS_VERSION}/iojs-v${IOJS_VERSION}-linux-x64.tar.gz" && \
    curl -SLO "https://iojs.org/dist/v${IOJS_VERSION}/SHASUMS256.txt.asc" && \
    gpg --verify SHASUMS256.txt.asc && \
    grep " iojs-v${IOJS_VERSION}-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - && \
    tar -xzf "iojs-v${IOJS_VERSION}-linux-x64.tar.gz" -C /usr/local --strip-components=1 && \
    rm "iojs-v${IOJS_VERSION}-linux-x64.tar.gz" SHASUMS256.txt.asc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
