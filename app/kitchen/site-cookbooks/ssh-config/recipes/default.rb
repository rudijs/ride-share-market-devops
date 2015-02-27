#
# Cookbook Name:: ssh-config
# Recipe:: default
#
# Copyright (C) 2015 Ride Share Market
#
# All rights reserved - Do Not Redistribute
#
# Get then encrypted secrets
include_recipe "secrets"

raise "Missing required portknock sequences." if !node["secrets"]["data"]['portknock']['sequences']

include_recipe "ssh-config::port_knock"

include_recipe "ssh-config::ssh_config"
