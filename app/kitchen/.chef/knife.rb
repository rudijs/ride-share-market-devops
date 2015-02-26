cookbook_path ["berks-cookbooks", "site-cookbooks"]
node_path "nodes"
role_path "roles"
environment_path "environments"
data_bag_path "data_bags"
#encrypted_data_bag_secret "data_bag_key"

knife[:berkshelf_path] = "berks-cookbooks"

knife[:digital_ocean_access_token] = "#{ENV['RSMCOM_DIGITAL_OCEAN_ACCESS_TOKEN']}"

# https://manage.chef.io/organizations/rsmcom
log_level :info
log_location STDOUT
node_name "rsm"
client_key "#{ENV['HOME']}/.ssh/rsmcom/rsm.pem"
validation_client_name "rsmcom-validator"
validation_key "#{ENV['HOME']}/.ssh/rsmcom/rsmcom-validator.pem"
chef_server_url "https://api.opscode.com/organizations/rsmcom"
syntax_check_cache_path "#{ENV['HOME']}/.chef/syntaxcache"
