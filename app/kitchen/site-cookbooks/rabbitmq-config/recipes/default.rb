#
# Cookbook Name:: rabbitmq-config
# Recipe:: default
#
# Copyright (C) 2015 Ride Share Market
#
# All rights reserved - Do Not Redistribute
#
include_recipe "secrets::default"

raise "Missing required rabbitmq secrets: enabled_users" if !node["secrets"]["data"]['rabbitmq']['enabledUsers']

include_recipe "rabbitmq"
include_recipe "rabbitmq::mgmt_console"
include_recipe "rabbitmq::virtualhost_management"

node.default["rabbitmq"]["enabled_users"] = node["secrets"]["data"]['rabbitmq']['enabledUsers']

include_recipe "rabbitmq::user_management"
