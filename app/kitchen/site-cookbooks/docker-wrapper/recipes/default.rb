#
# Cookbook Name:: docker-wrapper
# Recipe:: default
#
# Copyright (C) 2015 Ride Share Market
#
# All rights reserved - Do Not Redistribute
#
# Needed linux-image-extra for aufs filesystem support
package "linux-image-extra-`uname -r`"

include_recipe "docker"
