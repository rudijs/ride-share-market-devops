require 'open3'
require "./docker_registry"
require 'optparse'

# Options
Options = Struct.new(
    :host,
    :port,
    :env,
    :dry_run
)

# Option Defaults
args = Options.new(
    "192.168.33.10",
    5000,
    nil,
    false
)

# Set commandline Options
OptionParser.new do |opts|
  opts.banner = "Usage: docker-deploy.rb [options]"

  opts.on("-nHOST", "--hostname=HOST", "Docker Private Registry hostname/IP address") do |h|
    args.host = h
  end

  opts.on("-pPORT", "--port=PORT", "Docker Private Registry port") do |p|
    args.port = p
  end

  opts.on("-eENV", "--env=ENV", "Node application environment") do |e|
    args.env = e
  end

  opts.on("-d", "--dry-run", "Execute Dry Run only, print commands only") do |d|
    args.dry_run = d
  end

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end

end.parse!

if args.env == nil
  fail "Missing required argument '--env'"
end

docker_registry_host = args.host
docker_registry_port = args.port
node_application_env = args.env
dry_run = args.dry_run

docker_registry = DockerRegistry.new({
                                         :registry_host => docker_registry_host,
                                         :registry_port => docker_registry_port
                                     })

rsm_logstash_forwarder_image = "#{docker_registry_host}:#{docker_registry_port}/rudijs/rsm-logstash-forwarder:#{docker_registry.get_image_current_version("rudijs/rsm-logstash-forwarder")}"
rsm_data_image = "#{docker_registry_host}:#{docker_registry_port}/rudijs/rsm-data:#{docker_registry.get_image_current_version("rudijs/rsm-data")}"
rsm_api_image = "#{docker_registry_host}:#{docker_registry_port}/rudijs/rsm-api:#{docker_registry.get_image_current_version("rudijs/rsm-api")}"
rsm_app_image = "#{docker_registry_host}:#{docker_registry_port}/rudijs/rsm-app:#{docker_registry.get_image_current_version("rudijs/rsm-app")}"
rsm_nginx_image = "#{docker_registry_host}:#{docker_registry_port}/rudijs/rsm-nginx:#{docker_registry.get_image_current_version("rudijs/rsm-nginx")}"

def run_command(dry_run, cmd)
  puts "==> #{cmd}"
  if !dry_run
    Open3.popen3(cmd) { |stdin, stdout, stderr, wait_thr|
      while line = stdout.gets
        puts line
      end
      exit_status = wait_thr.value
      unless exit_status.success?
        #abort "==> FAILED !!! #{cmd}"
        puts "==> FAILED !!! #{cmd}"
      end
    }
  end
end

# Pull
run_command dry_run, "sudo docker pull #{rsm_logstash_forwarder_image}"
run_command dry_run, "sudo docker pull #{rsm_data_image}"
run_command dry_run, "sudo docker pull #{rsm_api_image}"
run_command dry_run, "sudo docker pull #{rsm_app_image}"
run_command dry_run, "sudo docker pull #{rsm_nginx_image}"

# Destroy RSM Docker containers in specific order
rsm_containers = [
    "rsm-nginx-logstash-forwarder",
    "rsm-nginx",

    "rsm-api-logstash-forwarder",
    "rsm-api",

    "rsm-app-logstash-forwarder",
    "rsm-app",

    "rsm-data-logstash-forwarder",
    "rsm-data"
]
rsm_containers.each do |container|
  run_command dry_run, "sudo docker rm -f -v #{container}"
end

# Deploy RSM Docker containers in specific order
run_command dry_run, "sudo docker run -d --restart always --name rsm-data --env 'NODE_ENV=#{node_application_env}' --cap-add SYS_PTRACE --security-opt apparmor:unconfined #{rsm_data_image}"
run_command dry_run, "sudo docker run -d --restart always --name rsm-data-logstash-forwarder --add-host vbox.ridesharemarket.com:192.168.33.10 -v /etc/pki/tls:/etc/pki/tls --volumes-from rsm-data -t #{rsm_logstash_forwarder_image} '--quiet=true' '--config=/srv/ride-share-market-data/config/logstash-forwarder.json'"

run_command dry_run, "sudo docker run -d --restart always --name rsm-api --env 'NODE_ENV=#{node_application_env}' --add-host met01.dev.vbx.ridesharemarket.com:192.168.33.10 --cap-add SYS_PTRACE --security-opt apparmor:unconfined #{rsm_api_image}"
run_command dry_run, "sudo docker run -d --restart always --name rsm-api-logstash-forwarder --add-host vbox.ridesharemarket.com:192.168.33.10 -v /etc/pki/tls:/etc/pki/tls --volumes-from rsm-api -t #{rsm_logstash_forwarder_image} '--quiet=true' '--config=/srv/ride-share-market-api/config/logstash-forwarder.json'"

run_command dry_run, "sudo docker run -d --restart always --name rsm-app --env 'NODE_ENV=#{node_application_env}' --cap-add SYS_PTRACE --security-opt apparmor:unconfined #{rsm_app_image}"
run_command dry_run, "sudo docker run -d --restart always --name rsm-app-logstash-forwarder --add-host vbox.ridesharemarket.com:192.168.33.10 -v /etc/pki/tls:/etc/pki/tls --volumes-from rsm-app -t #{rsm_logstash_forwarder_image} '--quiet=true' '--config=/srv/ride-share-market-app/config/logstash-forwarder.json'"

run_command dry_run, "sudo docker run -d --restart always --name rsm-nginx --volumes-from rsm-app --link rsm-app:rsm-app --link rsm-api:rsm-api -p 80:80 -p 443:443 #{rsm_nginx_image}"
run_command dry_run, "sudo docker run -d --restart always --name rsm-nginx-logstash-forwarder --add-host vbox.ridesharemarket.com:192.168.33.10 -v /etc/pki/tls:/etc/pki/tls --volumes-from rsm-nginx -t #{rsm_logstash_forwarder_image} '--quiet=true' '--config=/etc/nginx/logstash-forwarder.json'"
