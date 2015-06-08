#!/opt/chef/embedded/bin/ruby

require 'open3'
require './docker-container'

docker_registry = "192.168.33.10:5000"

container_domain = "rudijs"

container_name_parts = ARGV[0].split(":")

container_name = container_name_parts[0]

container_version = container_name_parts[1]

docker_image = "#{docker_registry}/#{container_domain}/#{container_name}:#{container_version}"

def run_command(cmd)
  puts "==> #{cmd}"
  Open3.popen3(cmd) { |stdin, stdout, stderr, wait_thr|
    while line = stdout.gets
      puts line
    end
    exit_status = wait_thr.value
    unless exit_status.success?
      abort "==> FAILED !!! #{cmd}"
    end
  }
end

nginx = DockerContainer.new("rsm-nginx")
nginx_restart_cmd = nginx.restart_command

logstash = DockerContainer.new("rsm-app-logstash-forwarder")
logstash_restart_cmd = logstash.restart_command

cmd = "sudo docker pull #{docker_image}"
run_command(cmd)

# Note: the *--cap-add SYS_PTRACE --security-opt apparmor:unconfined* flags above are required for pm2. See [here](https://github.com/Unitech/PM2/issues/1086)
cmd = "sudo docker rm -f -v #{container_name} && sudo docker run -d --restart always --name #{container_name} --env 'NODE_ENV=vbx' --cap-add SYS_PTRACE --security-opt apparmor:unconfined #{docker_image}"

run_command(cmd)

run_command(nginx_restart_cmd)

run_command(logstash_restart_cmd)
