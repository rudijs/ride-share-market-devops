node["ssh-config"]["users"].each do |user|

  # Port knocking tool
  template "/home/#{user}/portknock-ssh1" do
    source "portknock_ssh1.erb"
    owner user
    group user
    mode "0755"
    variables({
                  :knockd_sequence => node["secrets"]["data"]["portknock"]["sequences"]["brieflyOpenSsh"]
              })
  end

  # Port knocking tool
  template "/home/#{user}/portknock-ssh2" do
    source "portknock_ssh2.erb"
    owner user
    group user
    mode "0755"
    variables({
                  :knockd_sequence => node["secrets"]["data"]["portknock"]["sequences"]["limitedlyOpenSsh"]
              })
  end

  # Port knocking tool
  template "/home/#{user}/portknock-ssh2-close" do
    source "portknock_ssh2_close.erb"
    owner user
    group user
    mode "0755"
    variables({
                  :knockd_sequence => node["secrets"]["data"]["portknock"]["sequences"]["closeLimitedlyOpenSsh"]
              })
  end

end
