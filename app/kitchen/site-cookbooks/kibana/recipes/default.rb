#
# Cookbook Name:: kibana
# Recipe:: default
#
# Copyright (C) 2015 Ride Share Market
#
# All rights reserved - Do Not Redistribute
#
include_recipe "kibana::install"

include_recipe "kibana::configure"
