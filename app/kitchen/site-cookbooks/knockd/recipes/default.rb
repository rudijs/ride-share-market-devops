#
# Cookbook Name:: knockd
# Recipe:: default
#
# Copyright (C) 2015 Ride Share Market
#
# All rights reserved - Do Not Redistribute
#
include_recipe "secrets::default"

include_recipe "knockd::install"

include_recipe "knockd::configure"
