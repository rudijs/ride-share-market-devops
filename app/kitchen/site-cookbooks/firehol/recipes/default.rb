#
# Cookbook Name:: firehol
# Recipe:: default
#
# Copyright (C) 2015 Ride Share Market
#
# All rights reserved - Do Not Redistribute
#
include_recipe "secrets::default"

include_recipe "firehol::install"

include_recipe "firehol::configure"