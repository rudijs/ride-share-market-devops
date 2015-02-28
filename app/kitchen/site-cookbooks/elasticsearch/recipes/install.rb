apt_repository "elasticsearch" do
  uri           "http://packages.elasticsearch.org/elasticsearch/1.4/debian"
  distribution  "stable main"
  key "https://packages.elasticsearch.org/GPG-KEY-elasticsearch"
end

package "openjdk-7-jre"
package "elasticsearch"

service "elasticsearch" do
  action [ :enable, :start ]
end