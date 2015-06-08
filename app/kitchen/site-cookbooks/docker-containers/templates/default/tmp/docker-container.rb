require 'open3'
require 'json'

class DockerContainer
  def initialize(container_name)
    @container_name = container_name
  end

  def restart_command

    container_details = docker_inspect @container_name

    container = {
        :name => get_container_name(container_details),
        :volumes_from => get_container_volumes_from(container_details),
        :links => get_container_links(container_details),
        :ports => get_container_ports(container_details),
        :args => get_container_args(container_details),
        :binds => get_container_binds(container_details),
        :hosts => get_container_hosts(container_details),
        :image => get_container_image(container_details)
    }

    restart_container_command = [
        "sudo docker",
        "rm -f -v",
        @container_name,
        "&&",
        "sudo docker",
        "run -d",
        "--restart always",
        "--name #{@container_name}",
        format_container_volumes_from(container[:volumes_from]).join(" "),
        format_container_links(container[:links]).join(" "),
        format_container_binds(container[:binds]).join(" "),
        format_container_hosts(container[:hosts]).join(" "),
        format_container_ports(container[:ports]).join(" "),
        container[:image],
        format_container_args(container[:args]).join(" "),
    ].join(" ")

  end

  private

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
  end

  def get_container_image(obj)
    obj["Config"]["Image"]
  end

  def get_container_links(obj)
    obj["HostConfig"]["Links"] || []
  end

  def get_container_args(obj)
    obj["Args"] || []
  end

  def get_container_binds(obj)
    obj["HostConfig"]["Binds"] || []
  end

  def get_container_ports(obj)
    # hostPort:containerPort
    obj["HostConfig"]["PortBindings"] || {}
  end

  def get_container_hosts(obj)
    obj["HostConfig"]["ExtraHosts"] || []
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

  def format_container_args(args)
    args.map { |arg|
      "'#{arg}'"
    }
  end

  def format_container_binds(binds)
    binds.map { |bind|
      "-v #{bind}"
    }
  end

  def format_container_hosts(hosts)
    hosts.map { |host|
      "--add-host #{host}"
    }
  end

end
