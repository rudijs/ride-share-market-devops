FROM ubuntu:14.04
MAINTAINER Ride Share Market "systemsadmin@ridesharemarket.com"

# APT cache
ENV APT_REFRESHED_AT 2015-06-01.1
RUN apt-get -yqq update

# Install Nginx
RUN \
    apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository ppa:nginx/stable  && \
    apt-get -yqq update && \
    apt-get install -y nginx && \
    rm -rf /var/lib/apt/lists/* && \
    echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
    chown -R www-data.www-data /var/lib/nginx && \
    mkdir /etc/nginx/ssl && \
    rm /etc/nginx/sites-enabled/default && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ssl/ridesharemarket.com.crt /etc/nginx/ssl/ridesharemarket.com.crt
COPY ssl/ridesharemarket.com.key /etc/nginx/ssl/ridesharemarket.com.key
COPY ssl/dhparam.pem /etc/nginx/ssl/dhparam.pem

COPY sites-available/ridesharemarket.com.conf /etc/nginx/sites-available/ridesharemarket.com
COPY sites-available/api.ridesharemarket.com.conf /etc/nginx/sites-available/api.ridesharemarket.com
RUN \
    ln -s /etc/nginx/sites-available/ridesharemarket.com /etc/nginx/sites-enabled/ridesharemarket.com && \
    ln -s /etc/nginx/sites-available/api.ridesharemarket.com /etc/nginx/sites-enabled/api.ridesharemarket.com

COPY docker-start.sh /etc/init.d/docker-start.sh

# Define mountable directories.
VOLUME /var/log/nginx

# Define default command.
CMD ["/etc/init.d/docker-start.sh"]
