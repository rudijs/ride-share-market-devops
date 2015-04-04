## Create

- Provision the server.
- `./devops.rb server_create redline`
- Update data_bags/network json file with the Digital Ocean Instance ID.
- Update data_bags/network json file with the Digital public IP address.
- Update /etc/hosts
- `./network_hosts.rb | sudo tee -a /etc/hosts && sudo vi /etc/hosts`
- Update DNS (see below).
- Create Ubuntu user account (for all future devops operations)
- `./devops.rb create_ubuntu_account --user root --hostname redline`
- Upgrade the server.
- `./devops.rb upgrade --user ubuntu --hostname redline`
- Reboot the server (sanity check plus reboot into any new linux kernel).
- `./devops.rb reboot --user ubuntu --hostname redline`
- Bootstrap the server, which includes:
- apt-get autoremove.
- Copy in the chef secret key.
- Bootstrap Chef Node.
- `./devops.rb server_bootstrap redline`
- Reboot the server and confirm boot up email received.
- `./devops.rb reboot --user ubuntu --hostname redline`

## Destroy

- Destroy Digital Ocean instance.
- Delete Chef Node.
- Delete Chef Client.
- Remove .ssh/known_hosts entries.
- `./devops.rb server_delete redline`

## DNS

- Create
- `knife digital_ocean domain create --name ridesharemarket.com -ip-address xxx.xxx.xxx.xxx`
- `knife digital_ocean domain record create --domain-id ridesharemarket.com --type CNAME --name www --data @`
- `knife digital_ocean domain record create --domain-id ridesharemarket.com --type A --name redline --data xxx.xxx.xxx.xxx`
- Update (remove then add)
- `knife digital_ocean domain record list -D ridesharemarket.com`
- Find the ID of the record to remove
- `knife digital_ocean domain record destroy --domain-id ridesharemarket.com --record-id 5563232`
- `knife digital_ocean domain record create --domain-id ridesharemarket.com --type A --name redline --data xxx.xxx.xxx.xxx`
