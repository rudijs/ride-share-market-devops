raise "Missing required portknock sequences" if !node["secrets"]["data"]['firehol']['hosts']

# Find all known dev and prd machine public IPs for consul monitoring network
consul_hosts = []

node["firehol"]["network"]["consul"].each { |network_data|

  network = data_bag_item("network", network_data)

  network["hosts"].each { |host|

    if IPAddress.valid? host["digitalOcean"]["ip"]["eth0"]
      consul_hosts.push(host["digitalOcean"]["ip"]["eth0"])
    end

  }

}

template "/etc/default/firehol" do
  source "etc_default_firehol.erb"
  owner "root"
  group "root"
  mode "0644"
  variables({
                :start_firehol => node["firehol"]["start_firehol"]
            })
end

template "/etc/firehol/firehol.conf" do
  source "firehol.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables({
                :virtual_box_hosts => node["firehol"]["virtual_box_hosts"],
                :hosts => node["secrets"]["data"]['firehol']['hosts'],
                :consul_hosts => consul_hosts.join(" ")
            })
end
