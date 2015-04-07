FROM ubuntu:14.04
MAINTAINER Ride Share Market "systemsadmin@ridesharemarket.com"

# APT cache
ENV APT_REFRESHED_AT 2015-04-05.1
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
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ridesharemarket.com.conf /etc/nginx/sites-available/ridesharemarket.com
COPY ssl/ridesharemarket.com.cert /etc/nginx/ssl/ridesharemarket.com.cert
COPY ssl/ridesharemarket.com.key /etc/nginx/ssl/ridesharemarket.com.key
RUN ln -s /etc/nginx/sites-available/ridesharemarket.com /etc/nginx/sites-enabled/ridesharemarket.com

# Define mountable directories.
VOLUME "/var/log/nginx"

# Define working directory.
WORKDIR /etc/nginx

# Define default command.
CMD ["nginx"]
