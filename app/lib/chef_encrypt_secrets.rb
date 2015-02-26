#!/usr/bin/env ruby

# This script will encrypt plain text secrets.json to data_bags/secrets/secrets.json

# Required source:  kitchen/.chef/chef_secret_key.txt
# Required source:  kitchen/.chef/secrets.json

# Sources for both for required files is copied from KeePass

require 'chef/encrypted_data_bag_item'

secret_key_path = "#{File.dirname(__FILE__)}/../kitchen/.chef/chef_secret_key.txt"

secrets_json_path = "#{File.dirname(__FILE__)}/../kitchen/.chef/secrets.json"

encrypted_secrets_json_path = File.join(File.dirname(__FILE__), "/../kitchen/data_bags/secrets/secrets.json")

raise "File Not Found Secret Key" if !File.exist?(secret_key_path)

secret_key = Chef::EncryptedDataBagItem.load_secret(secret_key_path)

secrets = JSON.parse(File.read(secrets_json_path));

data_bag = { "id" => "secrets", "data" => secrets["data"] }

encrypted_data_bag = Chef::EncryptedDataBagItem.encrypt_data_bag_item(data_bag, secret_key)

File.open( encrypted_secrets_json_path, 'w') do |f|
  f.print encrypted_data_bag.to_json
  puts "* #{secrets_json_path} encrypted to #{encrypted_secrets_json_path}"
  puts "+ Please ensure KeePass is updated with the current data that was just encrypted."
  puts "+ You may now safely delete if no longer required: #{secrets_json_path}"
end
