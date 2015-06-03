#!/usr/bin/env ruby

require "json"

class Docker
  def initialize
    @images = "#{Dir.pwd}/../kitchen/data_bags/docker/rsm.json"
    @images_meta_data = read_json(@images)
  end

  def read_json(file)
    JSON.parse(File.read(file))
  end

  def pull
    @images_meta_data["images"].each {|image, uri|
      puts "sudo docker pull #{uri}"
    }
  end

  def deploy
    puts "sudo docker run -d --restart always --name rsm-data --cap-add SYS_PTRACE --security-opt apparmor:unconfined #{@images_meta_data["images"]["rsm-data"]}"

    puts "sudo docker run -d --restart always --name rsm-api --env 'NODE_ENV=vbx' --add-host met01.dev.vbx.ridesharemarket.com:192.168.33.10 --cap-add SYS_PTRACE --security-opt apparmor:unconfined #{@images_meta_data["images"]["rsm-api"]}"
    puts "sudo docker run -d --restart always --name rsm-api-logstash-forwarder --add-host vbox.ridesharemarket.com:192.168.33.10 -v /etc/pki/tls:/etc/pki/tls --volumes-from rsm-api -t #{@images_meta_data["images"]["rsm-logstash-forwarder"]} '--quiet=true' '--config=/srv/ride-share-market-api/config/logstash-forwarder.json'"

    puts "sudo docker run -d --restart always --name rsm-app --env 'NODE_ENV=vbx' --cap-add SYS_PTRACE --security-opt apparmor:unconfined #{@images_meta_data["images"]["rsm-app"]}"
    puts "sudo docker run -d --restart always --name rsm-app-logstash-forwarder --add-host vbox.ridesharemarket.com:192.168.33.10 -v /etc/pki/tls:/etc/pki/tls --volumes-from rsm-app -t #{@images_meta_data["images"]["rsm-logstash-forwarder"]} '--quiet=true' '--config=/srv/ride-share-market-app/config/rsm-app-logstash-forwarder.json'"

    puts "sudo docker run -d --restart always --name rsm-nginx --volumes-from rsm-app --link rsm-app:rsm-app --link rsm-api:rsm-api -p 80:80 -p 443:443 #{@images_meta_data["images"]["rsm-nginx"]}"
  end

  def destroy_containers
    @images_meta_data["containers"].each {|container|
      puts "sudo docker rm -f -v #{container}"
    }
  end

end

docker = Docker.new

docker.pull

docker.destroy_containers

docker.deploy
