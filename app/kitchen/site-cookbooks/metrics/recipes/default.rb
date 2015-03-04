#
# Cookbook Name:: metrics
# Recipe:: default
#
# Copyright (C) 2015 Ride Share Market
#
# All rights reserved - Do Not Redistribute
#
include_recipe "graphite-config"
include_recipe "statsdaemon-bitly"
