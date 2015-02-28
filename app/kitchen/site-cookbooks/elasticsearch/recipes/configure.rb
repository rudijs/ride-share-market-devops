service "elasticsearch" do
  supports :restart => true
  action :nothing
end

template "/etc/elasticsearch/elasticsearch.yml" do
  source "elasticsearch.yml.erb"
  owner "root"
  group "root"
  mode "0644"
  variables({
               :cluster_name => node["elasticsearch"]["cluster_name"]
           })
  notifies :restart, "service[elasticsearch]", :immediately
end
