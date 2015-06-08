# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'ridesharemarket.com'
# set :repo_url, 'git@example.com:me/my_repo.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

set :ssh_options, {forward_agent: true}

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :default_env, {path: "/opt/chef/embedded/bin:$PATH"}

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

set :rsm_web_app_repos, fetch(:rsm_web_app_repos, []).push(
                          {
                              git: 'git@github.com:rudijs/ride-share-market-api.git',
                              config_src: File.join(File.dirname(__FILE__), "/../../../ride-share-market-api/config/env/#{fetch(:stage)}.json"),
                              config_dst: "ride-share-market-api/config/env"
                          },
                          {
                              git: 'git@github.com:rudijs/ride-share-market-app.git',
                              config_src: File.join(File.dirname(__FILE__), "/../../../ride-share-market-app/config/env/#{fetch(:stage)}.json"),
                              config_dst: "ride-share-market-app/config/env"
                          }
                      )

set :docker_repos, fetch(:rsm_docker_repos, []).push(
                     'docker/iojs'
                 )

desc "Docker Repos"
task :docker_repos do
  on roles(:app) do |host|
    fetch(:docker_repos, []).each do |repo|
      if test "[ ! -d docker ]"
        execute :mkdir, "docker"
      end
      upload! repo, repo, recursive: true
    end
  end
end


desc "RSM Repos"
task :rsm_repos do
  on roles(:app) do |host|
    puts "Host: #{host} ==> #{fetch(:stage)}"
    fetch(:rsm_web_app_repos, []).each do |repo|
      puts "git clone -b #{fetch(:branch)} #{repo[:git]}"
      upload! repo[:config_src], repo[:config_dst]
      upload! repo[:config_src], "/tmp/xyz/abc/1.json"
    end
  end
end

desc "Report Uptimes"
task :uptime do
  on roles(:all) do |host|
    execute "uptime"
    info "Host #{host} (#{host.roles.to_a.join(', ')}):\t#{capture(:uptime)}"
  end
end

desc "Deploy Docker App"
task :docker_deploy do
  on roles(:all) do |host|
    upload! 'kitchen/data_bags/docker/rsm.json', 'rsm.json'
    execute "~/docker.rb > ~/deploy.sh"
    execute "sh ~/deploy.sh"
    info "Host #{host} (#{host.roles.to_a.join(', ')}):\t#{capture(:uptime)}"
  end
end