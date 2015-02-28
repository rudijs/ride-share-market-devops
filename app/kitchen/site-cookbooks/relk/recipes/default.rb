#
# Cookbook Name:: relk
# Recipe:: default
#
# Copyright (C) 2015 Ride Share Market
#
# All rights reserved - Do Not Redistribute
#
include_recipe "rabbitmq-config"
include_recipe "elasticsearch"
include_recipe "logstash"
include_recipe "kibana"
