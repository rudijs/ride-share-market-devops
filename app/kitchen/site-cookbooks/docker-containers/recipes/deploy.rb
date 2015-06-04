node["docker"]["users"].each {|user|
  template "#{user[:home]}/docker.rb" do
    source "docker.rb"
    owner user[:user]
    group user[:user]
    mode 0755
  end
}
