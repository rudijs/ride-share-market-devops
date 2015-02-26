require "json"

class DigitalOcean

  def initialize
    @network = "dev.ams.ridesharemarket.com"
    @file_path = File.join(File.dirname(__FILE__), "/../kitchen/data_bags/network/#{@network}.json")
    @data_hash = JSON.parse(File.read(@file_path))
  end

  def pretty_print(hash)
    puts JSON.pretty_generate(hash)
  end

  def strip_sub_domains(uri)
    domain_parts = uri.split('.').reverse
    "#{domain_parts[1]}.#{domain_parts[0]}"
  end

  def hosts
    puts @data_hash["hosts"].map { |host|
           puts "Hostname: #{host["id"]}.#{strip_sub_domains @data_hash["id"]} (Roles: #{host["roles"].join(",")})"
         }
  end

  def create(name)
    puts "==> Creating and Bootstrapping Digital Ocean Droplet: #{name}"

    new_server = @data_hash["hosts"].select { |host|
      host["id"] == name
    }

    raise "Host not found: #{name}" if new_server.size == 0

    digital_ocean_defaults = new_server[0].fetch("digitalOcean") { @data_hash["defaults"]["digitalOcean"] }

    digital_ocean = {
        :image => digital_ocean_defaults.fetch("image") { @data_hash["defaults"]["digitalOcean"]["image"] },
        :size => digital_ocean_defaults.fetch("size") { @data_hash["defaults"]["digitalOcean"]["size"] },
        :location => digital_ocean_defaults.fetch("location") { @data_hash["defaults"]["digitalOcean"]["location"] },
        :ssh_keys => digital_ocean_defaults.fetch("sshKeys") { @data_hash["defaults"]["digitalOcean"]["sshKeys"] },
        :booleans => digital_ocean_defaults.fetch("booleans") { @data_hash["defaults"]["digitalOcean"]["booleans"] }
    }

    digital_ocean_booleans = digital_ocean[:booleans].map { |do_boolean|
      "--" + do_boolean.to_s
    }

    # cmd = "knife digital_ocean droplet create --yes --server-name #{name} --image #{digital_ocean[:image]} --size #{digital_ocean[:size]} --location #{digital_ocean[:location]} --ssh-keys #{digital_ocean[:ssh_keys].join(',')} #{digital_ocean_booleans.join(' ')} --bootstrap --run-list 'recipe[common]' --json-attributes '#{new_server[0]["chefJsonAttributes"].to_json}'"
    cmd = "knife digital_ocean droplet create --yes --server-name #{name} --image #{digital_ocean[:image]} --size #{digital_ocean[:size]} --location #{digital_ocean[:location]} --ssh-keys #{digital_ocean[:ssh_keys].join(',')} #{digital_ocean_booleans.join(' ')}"
    puts "==> #{cmd}"; system cmd

  end

  def bootstrap(name)
    puts "==> Bootstrapping Digital Ocean Droplet: #{name}"

    new_server = @data_hash["hosts"].select { |host|
      host["id"] == name
    }

    raise "Host not found: #{name}" if new_server.size == 0

    cmd = "knife bootstrap #{name} --yes --node-name #{name} --ssh-user root --run-list 'recipe[common]' --json-attributes '#{new_server[0]["chefJsonAttributes"].to_json}'"
    puts "==> #{cmd}"; system cmd

  end

  def delete_server(name)

    puts "==> Deleting Digital Ocean Droplet and Chef Server Node: #{name}"

    new_server = @data_hash["hosts"].select { |host|
      host["id"] == name
    }

    raise "Host not found: #{name}" if new_server.size == 0

    cmd = "knife digital_ocean droplet destroy --server #{new_server[0]["digitalOcean"]["id"]}"
    puts "==> #{cmd}"; system cmd

    cmd = "knife node delete #{name} --yes"
    puts "==> #{cmd}"; system cmd

    cmd = "knife client delete #{name} --yes"
    puts "==> #{cmd}"; system cmd

    cmd = "ssh-keygen -f /home/rudi/.ssh/known_hosts -R #{new_server[0]["digitalOcean"]["ip"]["eth0"]}"
    puts "==> #{cmd}"; system cmd

    cmd = "ssh-keygen -f /home/rudi/.ssh/known_hosts -R #{new_server[0]["id"]}"
    puts "==> #{cmd}"; system cmd

    if new_server[0]["roles"]
      new_server[0]["roles"].each { |role|
        cmd = "ssh-keygen -f /home/rudi/.ssh/known_hosts -R #{role}.#{@network}"
        puts "==> #{cmd}"; system cmd
      }
    end

    if new_server[0]["cnames"]
      new_server[0]["cnames"].each { |cname|
        cmd = "ssh-keygen -f /home/rudi/.ssh/known_hosts -R #{cname}"
        puts "==> #{cmd}"; system cmd
      }
    end

    cmd = "ssh-keygen -f /home/rudi/.ssh/known_hosts -R #{new_server[0]["chefJsonAttributes"]["set_fqdn"]}"
    puts "==> #{cmd}"; system cmd

  end


  def uptime
    @data_hash["hosts"].each { |host|
      cmd = "ssh -oStrictHostKeyChecking=no root@#{host["id"]} uptime"
      puts cmd; system cmd
    }
  end

end
