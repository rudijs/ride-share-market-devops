require 'open3'
require "./docker_registry"

docker_registry_host = "192.168.33.10"
docker_registry_port = 5000

docker_registry = DockerRegistry.new({
                                         :registry_host => docker_registry_host,
                                         :registry_port => docker_registry_port
                                     })

rsm_logstash_forwarder_image = "#{docker_registry_host}:#{docker_registry_port}/rudijs/rsm-logstash-forwarder:#{docker_registry.get_image_current_version("rudijs/rsm-logstash-forwarder")}"
rsm_data_image = "#{docker_registry_host}:#{docker_registry_port}/rudijs/rsm-data:#{docker_registry.get_image_current_version("rudijs/rsm-data")}"
rsm_api_image = "#{docker_registry_host}:#{docker_registry_port}/rudijs/rsm-api:#{docker_registry.get_image_current_version("rudijs/rsm-api")}"
rsm_app_image = "#{docker_registry_host}:#{docker_registry_port}/rudijs/rsm-app:#{docker_registry.get_image_current_version("rudijs/rsm-app")}"
rsm_nginx_image = "#{docker_registry_host}:#{docker_registry_port}/rudijs/rsm-nginx:#{docker_registry.get_image_current_version("rudijs/rsm-nginx")}"

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


# Pull
run_command "sudo docker pull #{rsm_logstash_forwarder_image}"
run_command "sudo docker pull #{rsm_data_image}"
run_command "sudo docker pull #{rsm_api_image}"
run_command "sudo docker pull #{rsm_app_image}"
run_command "sudo docker pull #{rsm_nginx_image}"

# Destroy
%w(rsm-nginx-logstash-forwarder rsm-nginx rsm-api-logstash-forwarder rsm-api rsm-app-logstash-forwarder rsm-app rsm-data-logstash-forwarder rsm-data).each do |container|
  run_command "sudo docker rm -f -v #{container}"
end

# Deploy

run_command "sudo docker run -d --restart always --name rsm-data --cap-add SYS_PTRACE --security-opt apparmor:unconfined #{rsm_data_image}"
run_command "sudo docker run -d --restart always --name rsm-data-logstash-forwarder --add-host vbox.ridesharemarket.com:192.168.33.10 -v /etc/pki/tls:/etc/pki/tls --volumes-from rsm-data -t #{rsm_logstash_forwarder_image} '--quiet=true' '--config=/srv/ride-share-market-data/config/logstash-forwarder.json'"

run_command "sudo docker run -d --restart always --name rsm-api --env 'NODE_ENV=vbx' --add-host met01.dev.vbx.ridesharemarket.com:192.168.33.10 --cap-add SYS_PTRACE --security-opt apparmor:unconfined #{rsm_api_image}"
run_command "sudo docker run -d --restart always --name rsm-api-logstash-forwarder --add-host vbox.ridesharemarket.com:192.168.33.10 -v /etc/pki/tls:/etc/pki/tls --volumes-from rsm-api -t #{rsm_logstash_forwarder_image} '--quiet=true' '--config=/srv/ride-share-market-api/config/logstash-forwarder.json'"

run_command "sudo docker run -d --restart always --name rsm-app --env 'NODE_ENV=vbx' --cap-add SYS_PTRACE --security-opt apparmor:unconfined #{rsm_app_image}"
run_command "sudo docker run -d --restart always --name rsm-app-logstash-forwarder --add-host vbox.ridesharemarket.com:192.168.33.10 -v /etc/pki/tls:/etc/pki/tls --volumes-from rsm-app -t #{rsm_logstash_forwarder_image} '--quiet=true' '--config=/srv/ride-share-market-app/config/logstash-forwarder.json'"

run_command "sudo docker run -d --restart always --name rsm-nginx --volumes-from rsm-app --link rsm-app:rsm-app --link rsm-api:rsm-api -p 80:80 -p 443:443 #{rsm_nginx_image}"
run_command "sudo docker run -d --restart always --name rsm-nginx-logstash-forwarder --add-host vbox.ridesharemarket.com:192.168.33.10 -v /etc/pki/tls:/etc/pki/tls --volumes-from rsm-nginx -t #{rsm_logstash_forwarder_image} '--quiet=true' '--config=/etc/nginx/logstash-forwarder.json'"

