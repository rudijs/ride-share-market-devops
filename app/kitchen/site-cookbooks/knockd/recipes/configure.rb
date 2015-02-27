raise "Missing required portknock sequences" if !node["secrets"]["data"]['portknock']['sequences']

template "/etc/default/knockd" do
  source "etc_default_knockd.erb"
  owner "root"
  group "root"
  mode "0644"
  variables({
                :start_knockd => node["knockd"]["start_knockd"],
                :knockd_opts => node["knockd"]["knockd_opts"]
            })
  notifies :restart, "service[knockd]"
end

template "/etc/knockd.conf" do
  source "knockd.conf.erb"
  owner "root"
  group "root"
  mode "0640"
  variables({
                :sequences => node["secrets"]["data"]['portknock']['sequences']
            })
  notifies :restart, "service[knockd]"
end
