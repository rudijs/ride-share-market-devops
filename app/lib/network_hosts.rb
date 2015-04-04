#!/usr/bin/env ruby

require "json"
require "ipaddress"

class NetworkHosts
  def initialize(hosts)
    @hosts = hosts
    @path = "#{Dir.pwd}/../kitchen/data_bags/network"
  end

  def network_data_bags
    Dir.glob("#{@path}/*.json")
  end

  def read_json(file)
    JSON.parse(File.read(file))
  end

  def network_uri(id)
    network_parts = id.split('_')
    uri = {
        :environment => network_parts[0],
        :location => network_parts[1],
        :domain => "#{network_parts[2]}.com"
    }
  end

  def host_roles(uri, roles)
    urls = []
    roles.each {|role|
      urls.push("#{role}.#{uri[:environment]}.#{uri[:location]}.#{uri[:domain]}")
    }
    urls
  end

  def host_unique_name(uri, id)
    unique_name = [id, "#{id}.#{uri[:domain]}"]
  end

  def hosts_entries

    hosts_comment = "### Ride Share Market: #{Time.now.strftime("%Y-%m-%d")}"
    puts hosts_comment

    network_data_bags.each { |data_bag|
      obj = read_json(data_bag)
      uri = network_uri(obj["id"])

      obj["hosts"].each {|host|

        hosts = []

        hosts += host_unique_name(uri, host["id"])
        hosts += host_roles(uri, host["roles"])
        if host["cnames"]
          hosts += host["cnames"]
        end

        puts "# Digital Ocean Droplet ID #{host["digitalOcean"]["id"]}"

        if IPAddress.valid? host["digitalOcean"]["ip"]["eth0"]
          puts "#{host["digitalOcean"]["ip"]["eth0"]} #{hosts.join(" ")}"
        end

      }

    }

  end

end

network_hosts = NetworkHosts.new(%w(dev_ams_ridesharemarket))

network_hosts.hosts_entries
