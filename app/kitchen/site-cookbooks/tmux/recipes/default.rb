#
# Cookbook Name:: tmux
# Recipe:: default
#
# Copyright (C) 2015 Ride Share Market
#
# All rights reserved - Do Not Redistribute
#
package "zsh"
package "tmux"

node["tmux"]["users"].each {|user|
  template "#{user[:home]}/.zshrc" do
    source "zshrc.erb"
    owner user[:user]
    group user[:user]
    mode 0644
  end
}

template "/etc/tmux.conf" do
  source "tmux.conf.erb"
  mode 0644
end

template "/etc/zsh/zshrc" do
  source "etc_zshrc.erb"
  mode 0644
end
