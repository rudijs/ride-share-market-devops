ssh_config_hosts = Array.new

network_hosts_dev = data_bag_item("network", "dev_ams_ridesharemarket")["hosts"]

# network_hosts_prd = data_bag_item("network", "prd_ams_ridesharemarket")["hosts"]

network_hosts = network_hosts_dev # + network_hosts_prd

network_host = Struct.new(:host, :host_name, :user)

network_hosts.each { |host|

  next if host.fetch("login", true) == false

  if IPAddress.valid? host["digitalOcean"]["ip"]["eth0"]
    ssh_config_hosts.push(network_host.new(
                        host["id"],
                        host["digitalOcean"]["ip"]["eth0"],
                        "ubuntu"
                    ))
  end
}

node["ssh-config"]["users"].each do |user|

  template "/home/#{user}/.ssh/config" do
    source "config.erb"
    owner user
    group user
    mode "0644"
    variables({
                  :ssh_config_hosts => ssh_config_hosts
              })
  end

  template "/home/#{user}/.bash_aliases" do
    source "bash_aliases.erb"
    owner user
    group user
    mode "0644"
    variables({
                  :ssh_config_hosts => ssh_config_hosts
              })
  end


end
