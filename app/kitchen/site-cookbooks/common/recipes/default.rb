#
# Cookbook Name:: common
# Recipe:: default
#
# Copyright (C) 2015 Ride Share Market
#
# All rights reserved - Do Not Redistribute
#
include_recipe "chef-client"
include_recipe "chef-client::delete_validation"
include_recipe "timezone-ii"
include_recipe "network-hosts"
include_recipe "hostname"
include_recipe "apt-get-periodic"
include_recipe "unattended_upgrades"
include_recipe "postfix"
include_recipe "postfix::aliases"
include_recipe "postfix::transports"
# include_recipe "postfix::_common"
include_recipe "packages"
include_recipe "notify-email-on-boot"
include_recipe "knockd"
include_recipe "firehol"
include_recipe "ssh-config"
