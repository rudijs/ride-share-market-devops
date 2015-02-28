service "rsyslog" do
  supports :restart => true
  action :nothing
end

template "/etc/rsyslog.d/100-logstash.conf" do
  source "rsyslog_logstash.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[rsyslog]"
end
