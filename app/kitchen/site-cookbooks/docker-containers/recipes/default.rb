#
# Cookbook Name:: docker-containers
# Recipe:: default
#
# Copyright (C) 2015 Ride Share Market
#
# All rights reserved - Do Not Redistribute
#
%w{ride-share-market-api ride-share-market-data}.each {|directory|
  directory "/srv/#{directory}/log" do
    recursive true
    owner "rsm-data"
    group "rsm-data"
  end
}
