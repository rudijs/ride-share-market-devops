# Local Developer Virtual Machine

## Install

- `cd app/kitchen`
- Update developer workstation */etc/hosts*
- `../lib/network_hosts.rb | sudo tee -a /etc/hosts && sudo vi /etc/hosts`
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

## Web Admin

- [RabbitMQ](http://vbox.ridesharemarket.com:15672)
- [Kibana](http://vbox.ridesharemarket.com:5601)
- [Graphite](http://vbox.ridesharemarket.com:8080)

## Docker

[Docker Install](../app/docker/README.md)

## Deployment

[Deployment](deployment.md)
