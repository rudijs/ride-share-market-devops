#
# Cookbook Name:: mongodb
# Recipe:: default
#
# Copyright (C) 2015 Ride Share Market
#
# All rights reserved - Do Not Redistribute
#
include_recipe "mongodb::install"

include_recipe "mongodb::configure"
