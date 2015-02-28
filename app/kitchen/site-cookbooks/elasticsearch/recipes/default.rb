#
# Cookbook Name:: elasticsearch
# Recipe:: default
#
# Copyright (C) 2015 Ride Share Market
#
# All rights reserved - Do Not Redistribute
#
include_recipe "elasticsearch::install"

include_recipe "elasticsearch::configure"