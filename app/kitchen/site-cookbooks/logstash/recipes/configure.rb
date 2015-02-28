template "/etc/init/logstash.conf" do
  source "logstash.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables({
                :settings => node["logstash"]["settings"]
            })
  notifies :restart, "service[logstash]"
end

rules = []
rules.push(node["logstash"]["settings"]["rules"])
rules.push(node["logstash"]["rules"]["services"])

rules.flatten.each do |f|
  template "/etc/logstash/conf.d/#{f}" do
    source "#{f}.erb"
    owner 'root'
    group 'root'
    mode '0644'
    variables({
                  :settings => node["logstash"]["settings"],
                  :rabbitmq_user => node["secrets"]["data"]['rabbitmq']['enabledUsers'][1]
              })
    notifies :restart, "service[logstash]"
  end
end
