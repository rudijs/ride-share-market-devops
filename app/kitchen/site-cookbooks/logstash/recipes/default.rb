#
# Cookbook Name:: logstash
# Recipe:: default
#
# Copyright (C) 2015 Ride Share Market
#
# All rights reserved - Do Not Redistribute
#
include_recipe "secrets::default"

raise "Missing required rabbitmq secrets: enabled_users" if !node["secrets"]["data"]['rabbitmq']['enabledUsers']

include_recipe "logstash::install"

include_recipe "logstash::configure"

include_recipe "logstash::rsyslog"

include_recipe "logstash::lumberjack"
