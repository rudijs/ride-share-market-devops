node["docker"]["users"].each {|user|

  template "#{user[:home]}/docker-deploy.rb" do
    source "docker-deploy.rb"
    owner user[:user]
    group user[:user]
  end

  template "#{user[:home]}/docker_registry.rb" do
    source "docker_registry.rb"
    owner user[:user]
    group user[:user]
  end

}
