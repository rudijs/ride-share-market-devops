#
# Cookbook Name:: notify-email-on-boot
# Recipe:: default
#
# Copyright (C) 2015 Ride Share Market
#
# All rights reserved - Do Not Redistribute
#
template '/etc/init/notify-email-on-boot.conf' do
  source 'notify-email-on-boot.conf.erb'
  mode '0644'
  variables({
                :mail_to => node["postfix"]["aliases"]["root"]
            })
end