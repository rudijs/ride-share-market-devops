FROM ubuntu:14.04
MAINTAINER Ride Share Market "systemsadmin@ridesharemarket.com"

# APT cache
ENV APT_REFRESHED_AT 2015-04-05.1
RUN apt-get -yqq update

# Required packages
RUN \
    apt-get -yqq install wget && \
    wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add - && \
    echo 'deb http://packages.elasticsearch.org/logstash/1.4/debian stable main' > /etc/apt/sources.list.d/logstash.list && \
    apt-get -yqq update && \
    apt-get -yqq install logstash && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV CONF_REFRESHED_AT 2015-04-05.1

COPY logstash.conf /etc/
COPY pattern_nginx.txt /opt/logstash/patterns/nginx

WORKDIR /opt/logstash

ENTRYPOINT [ "bin/logstash" ]

CMD [ "--config=/etc/logstash.conf" ]
