apt_repository "mongodb" do
  uri "http://downloads-distro.mongodb.org/repo/ubuntu-upstart"
  distribution "dist 10gen"
  keyserver "keyserver.ubuntu.com"
  key "7F0CEB10"
end

package "mongodb-org"

service "mongod" do
  supports :restart => true, :reload => true
  action [:enable, :start]
end
