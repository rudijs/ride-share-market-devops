apt_repository "logstash" do
  uri           "http://packages.elasticsearch.org/logstash/1.4/debian"
  distribution  "stable main"
  key "https://packages.elasticsearch.org/GPG-KEY-elasticsearch"
end

package "logstash"

service "logstash" do
  supports :restart => true, :reload => true
  action :nothing
end

# Will be using Elasticsearch and Kibana, no need for build in logstash-web

service "logstash-web" do
  action :stop
  only_if { ::File.exists?("/etc/init/logstash-web.conf") }
end

file "/etc/init/logstash-web.conf" do
  action :delete
end
