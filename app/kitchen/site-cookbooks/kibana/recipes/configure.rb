directory node["kibana"]["log_path"] do
  action :create
  owner node["kibana"]["user"]
  group "root"
  mode "0755"
end

template "/etc/init/kibana.conf" do
  source "kibana_upstart.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables({
                :settings => node["kibana"]
            })
end

service "kibana" do
  supports :restart => true
  action [:enable, :start]
  subscribes :restart, "/etc/init/kibana.conf", :immediately
end

template "#{node["kibana"]["extract_path"]}/config/kibana.yml" do
  source "kibana.yml.erb"
  owner "logstash"
  mode "0644"
  variables({
                :elasticsearch_url => node["kibana"]["elasticsearch_url"]
            })
  notifies :restart, "service[kibana]", :immediately
end

logrotate_app "kibana" do
  cookbook "logrotate"
  path "#{node["kibana"]["log_path"]}/#{node["kibana"]["log_file"]}"
  options ["missingok", "delaycompress", "notifempty"]
  frequency "daily"
  rotate 7
  create "664 logstash logstash"
  postrotate "service kibana restart > /dev/null"
end
