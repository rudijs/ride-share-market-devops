#
# Cookbook Name:: docker-containers
# Recipe:: default
#
# Copyright (C) 2015 Ride Share Market
#
# All rights reserved - Do Not Redistribute
#
directory "/srv/ride-share-market-data/log" do
  recursive true
  owner "rsm-data"
  group "rsm-data"
end
