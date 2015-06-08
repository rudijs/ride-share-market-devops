#!/opt/chef/embedded/bin/ruby

require 'open3'
require 'json'

container_name = ARGV[0]

def docker_inspect(container_name)
  Open3.popen3("sudo", "docker", "inspect", container_name) { |i, o, e, t|
    JSON.parse(o.read.chomp)[0]
  }
end

def get_container_name(obj)
  obj["Name"]
end

def get_container_volumes_from(obj)
  obj["HostConfig"]["VolumesFrom"] || []
  # [
  #     "rsm-data",
  #     "rsm-api",
  #     "rsm-app",
  #     "rsm-nginx"
  # ]
end

def get_container_image(obj)
  obj["Config"]["Image"]
end

def get_container_links(obj)
  obj["HostConfig"]["Links"] || []
  # [
  #     "/rsm-api:/rsm-nginx/rsm-api",
  #     "/rsm-app:/rsm-nginx/rsm-app"
  # ]
end

def get_container_ports(obj)
  # hostPort:containerPort
  obj["HostConfig"]["PortBindings"] || {}
  # {
  #     "443/tcp" => [
  #         {
  #             "HostIp" => "",
  #             "HostPort" => "443"
  #         }
  #     ],
  #     "80/tcp" => [
  #         {
  #             "HostIp" => "",
  #             "HostPort" => "80"
  #         }
  #     ]
  # }
end

def format_container_volumes_from(volumes)
  volumes.map { |volume|
    "--volumes-from #{volume}"
  }
end

def format_container_links(links)
  links.map { |link|
    link_parts = link.split(":")
    "--link #{link_parts[0].split("/")[link_parts[0].split("/").length-1]}:#{link_parts[1].split("/")[link_parts[1].split("/").length-1]}"
  }
end

def format_container_ports(ports)
  ports.map {|k,v|
    "-p #{ports[k][0]["HostPort"]}:#{k.split("/")[0]}"
  }
end

container_details = docker_inspect container_name

container = {
    :name => get_container_name(container_details),
    :volumes_from => get_container_volumes_from(container_details),
    :links => get_container_links(container_details),
    :ports => get_container_ports(container_details),
    :image => get_container_image(container_details)
}

# p container

# puts "sudo docker rm -f -v #{container_name} && sudo docker run -d --restart always --name #{container_name} #{format_container_volumes_from(container[:volumes_from]).join(" ")} #{format_container_links(container[:links]).join(" ")} #{container[:image]}"

restart_container_command = [
    "sudo docker",
    "rm -f -v",
    container_name,
    "&&",
    "sudo docker",
    "run -d",
    "--restart always",
    "--name #{container_name}",
    format_container_volumes_from(container[:volumes_from]).join(" "),
    format_container_links(container[:links]).join(" "),
    format_container_ports(container[:ports]).join(" "),
    container[:image]
]

puts restart_container_command.join(" ")
