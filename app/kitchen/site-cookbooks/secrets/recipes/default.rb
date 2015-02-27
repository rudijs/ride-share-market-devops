#
# Cookbook Name:: secrets
# Recipe:: default
#
# Copyright (C) 2015 Ride Share Market
#
# All rights reserved - Do Not Redistribute
#
# Cookbooks needing enrypted data_bags data will depend on this cookbook.
raise "File Not Found: required secret key for the 'secrets' cookbook" if !File.exist?(node["secrets"]["chef_secret_key"])

require 'chef/encrypted_data_bag_item'

secret_key = Chef::EncryptedDataBagItem.load_secret(node["secrets"]["chef_secret_key"])

secrets = Chef::EncryptedDataBagItem.load("secrets", "secrets", secret_key)

node.default["secrets"]["data"] = secrets["data"]
