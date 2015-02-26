#!/usr/bin/env ruby

require "thor"
require "ipaddress"
require "../lib/digital_ocean"

class MyCLI < Thor

  default = {
      :user => "vagrant",
      :hostname => "vbox.ridesharemarket.com",
      :vagrant_ip => "192.168.33.10",
      :secret_key => ".chef/chef_secret_key.txt",
      :cookbook => {
          :maintainer => "Ride Share Market",
          :maintainer_email => "systemsadmin@ridesharemarket.com"
      }
  }

  desc "init", "Copies configuration files from example/ into place"

  def init
    puts "==> Copying Chef configuration files"

    [
        '.chef/example'
    ].each do |path|
      system("cp -v #{path}/* #{path}/../")
    end
  end

  desc "sshcopyid", "Adds your ssh public key to a server"
  option :user, :default => default[:user]
  option :hostname, :default => default[:hostname]

  def sshcopyid()
    puts "==> Copying ssh public key to #{options[:hostname]}..."
    cmd = "ssh-copy-id #{options[:user]}@#{options[:hostname]}"
    puts "==> #{cmd}"; system cmd
  end

  desc "create_ubuntu_account", "Creates a user account named ubuntu with full sudoer permissions"
  option :user, :default => default[:user]
  option :hostname, :default => default[:hostname]

  def create_ubuntu_account
    puts "==> Creating the ubuntu user account on #{options[:hostname]}..."
    cmd = "ssh #{options[:user]}@#{options[:hostname]} useradd --comment Ubuntu --create-home --user-group --groups sudo --shell /bin/bash ubuntu"
    puts "==> #{cmd}"; system cmd
    puts "==> Creating ubuntu .ssh/authorized_keys on #{options[:hostname]}..."
    cmd = "ssh #{options[:user]}@#{options[:hostname]} 'mkdir -v /home/ubuntu/.ssh && chown -v ubuntu.ubuntu /home/ubuntu/.ssh && chmod -v 700 /home/ubuntu/.ssh'"
    puts "==> #{cmd}"; system cmd
    cmd = "ssh #{options[:user]}@#{options[:hostname]} 'cp -v /root/.ssh/authorized_keys /home/ubuntu/.ssh/ && chown -v ubuntu.ubuntu /home/ubuntu/.ssh/authorized_keys'"
    puts "==> #{cmd}"; system cmd
    puts "==> Updating sudo privileges for user account ubuntu on #{options[:hostname]}..."
    cmd = "ssh #{options[:user]}@#{options[:hostname]} 'echo \"ubuntu ALL=(ALL) NOPASSWD:ALL\" > /etc/sudoers.d/ubuntu && chmod -v 0440 /etc/sudoers.d/ubuntu'"
    puts "==> #{cmd}"; system cmd
  end

  desc "upgrade", "Upgrades server"
  option :user, :default => default[:user]
  option :hostname, :default => default[:hostname]

  def upgrade
    puts "==> Upgrading #{options[:hostname]}..."
    cmd = "ssh #{options[:user]}@#{options[:hostname]} -X 'sudo apt-get update && sudo aptitude safe-upgrade -y'"
    puts "==> #{cmd}"; system cmd
  end

  desc "reboot", "Reboots server"
  option :user, :default => default[:user]
  option :hostname, :default => default[:hostname]

  def reboot
    puts "==> Rebooting #{options[:hostname]}..."
    # TODO "vagrant reload" sometimes throws errors if new kernal (halt and manual restart instead?)
    if /^vbox/ =~ options[:hostname]
      cmd = "vagrant reload"
    else
      cmd = "ssh #{options[:user]}@#{options[:hostname]} 'sudo init 6'"
    end
    puts "==> #{cmd}"; system cmd
  end

  desc "bootstrap", "Bootstraps local virtualbox"
  option :user, :default => default[:user]
  option :hostname, :default => default[:hostname]

  def bootstrap
    puts "==> Apt-get Auto Remove before bootstrapping chef-solo on #{options[:hostname]}..."
    cmd = "ssh #{options[:user]}@#{options[:hostname]} -X 'sudo apt-get autoremove -y'"
    puts "==> #{cmd}"; system cmd
    puts "==> Bootstrapping chef-solo on #{options[:hostname]}..."
    cmd = "ssh #{options[:user]}@#{options[:hostname]} \"if ! [ -e /usr/bin/curl ]; then sudo apt-get install -y curl; else echo 'curl [OK]' ; fi\""
    puts "==> #{cmd}"; system cmd
    cmd = "ssh #{options[:user]}@#{options[:hostname]} \"if ! [ -e /opt/chef/bin/chef-solo ]; then curl -L https://www.chef.io/chef/install.sh | sudo bash; else echo 'Chef [OK]' ; fi\""
    puts "==> #{cmd}"; system cmd
  end

  desc "cook", "Runs knife solo cook"
  option :user, :default => default[:user]
  option :hostname, :default => default[:hostname]
  option :secret_key, :default => default[:secret_key]

  def cook

    # if !File.exists?(options[:secret_key])
    #   raise "Required File Not Found: #{options[:secret_key]}"
    # end

    # cmd = "scp #{options[:secret_key]} #{options[:user]}@#{options[:hostname]}:~/.ssh/chef_secret_key.txt"
    # puts "==> Uploading Chef Secret Key..."
    # puts "==> #{cmd}"; system cmd

    cmd = "knife solo cook --forward-agent --no-chef-check --no-berkshelf #{options[:user]}@#{options[:hostname]}"
    puts "==> Chef Solo Client Run..."
    puts "==> #{cmd}"; system cmd

    # cmd = "knife solo clean #{options[:user]}@#{options[:hostname]}"
    # puts "==> #{cmd}"; system cmd

    # cmd = "ssh #{options[:user]}@#{options[:hostname]} \"if [ -e ~/.ssh/chef_secret_key.txt ]; then rm -v ~/.ssh/chef_secret_key.txt; fi\""
    # puts "==> Cleaning up Chef Secret Key..."
    # puts "==> #{cmd}"; system cmd

  end

  desc "new_cookbook NAME", "Creates a new cookbook"
  option :maintainer, :default => default[:cookbook][:maintainer]
  option :maintainer_email, :default => default[:cookbook][:maintainer_email]

  def new_cookbook(name)
    puts "==> Creating new Berkshelf Cookbook #{name}..."
    system "berks cookbook --maintainer='#{options[:maintainer]}' --maintainer-email=#{options[:maintainer_email]} --license=reserved #{name} site-cookbooks/#{name}"
  end

  desc "server_create SERVER", "Creates and Bootstraps a new digitalocean.com droplet"

  def server_create(name)
    cloud = DigitalOcean.new
    cloud.create(name)
  end

  desc "server_bootstrap SERVER", "Bootstraps a digitalocean.com droplet"
  option :secret_key, :default => default[:secret_key]

  def server_bootstrap(name)

    if !File.exists?(options[:secret_key])
      raise "Required File Not Found: #{options[:secret_key]}"
    end

    puts "==> Apt-get Auto Remove before bootstrapping chef-solo on #{options[:hostname]}..."
    cmd = "ssh root@#{name} -X 'sudo apt-get autoremove -y'"
    puts "==> #{cmd}"; system cmd

    cmd = "scp #{options[:secret_key]} root@#{name}:~/.ssh/chef_secret_key.txt"
    puts "==> Uploading Chef Secret Key..."
    puts "==> #{cmd}"; system cmd

    cmd = "ssh root@#{name} 'chmod 600 ~/.ssh/chef_secret_key.txt'"
    puts "==> Updating Chef Secret Key Permissions..."
    puts "==> #{cmd}"; system cmd

    cloud = DigitalOcean.new
    cloud.bootstrap(name)
  end

  desc "server_list", "Lists known digitalocean.com droplets"

  def server_list
    cloud = DigitalOcean.new
    cloud.hosts
  end

  desc "server_delete SERVER", "Deletes a Digital Ocean Droplet and Chef Client Node"

  def server_delete(name)
    cloud = DigitalOcean.new
    cloud.delete_server(name)
  end

end

MyCLI.start(ARGV)
