# Local Developer Virtual Machine

## Install

Add the [hosts.txt](hosts.txt) entries to your */etc/hosts* file.


- `cd app/kitchen`
- `ssh-keygen -f ~/.ssh/known_hosts -R vbox.ridesharemarket.com`
- `ssh-keygen -f ~/.ssh/known_hosts -R 192.168.33.10`
- `vagrant plugin install vagrant-vbguest`
- `vagrant up`
- `./devops.rb sshcopyid`
- `./devops.rb upgrade`
- `./devops.rb reboot`
- `./devops.rb bootstrap`
- `berks vendor`
- `./devops.rb cook`
