template "/etc/mongod.conf" do
  source "mongod.conf.erb"
  notifies :restart, "service[mongod]"
end
