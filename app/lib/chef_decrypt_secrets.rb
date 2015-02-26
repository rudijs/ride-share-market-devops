#!/usr/bin/env ruby

require 'json'

require './decryptor'

secret_key_path = "#{File.dirname(__FILE__)}/../kitchen/.chef/chef_secret_key.txt"

secrets_path = File.join(File.dirname(__FILE__), "/../kitchen/data_bags/secrets/secrets.json")

raise "File Not Found Secret Key" if !File.exist?(secret_key_path)

raise "File Not Found Secrets JSON" if !File.exist?(secrets_path)

key = File.read(secret_key_path)

secrets = JSON.parse(File.read(secrets_path))

encrypted_data = secrets["data"]["encrypted_data"]

iv = secrets["data"]["iv"]

d = Decryptor.new(encrypted_data, key, iv)

puts d.decrypted_data
