## Create

- Provision the server.
- `./devops.rb server_create redline`
- Update data_bags/network json file with the Digital Ocean Instance ID and public IP address.
- Update /etc/hosts.
- Update DNS (see below).
- Upgrade the server.
- `./devops.rb upgrade --user root --hostname redline`
- Reboot the server (sanity check and possibly a new kernel).
- `./devops.rb reboot --user root --hostname redline`
- Bootstrap the server, which includes:
- apt-get autoremove.
- Copy in the chef secret key.
- Bootstrap Chef Node.
- `./devops.rb server_bootstrap redline`
- Reboot the server and confirm boot up email received.
- `./devops.rb reboot --user root --hostname redline`

## Destroy

- Destroy Digital Ocean instance.
- Delete Chef Node.
- Delete Chef Client.
- Remove .ssh/known_hosts entries.
- `./devops.rb server_delete redline`

## DNS

- Create
- `knife digital_ocean domain create --name ridesharemarket.com -ip-address 188.166.45.226`
- `knife digital_ocean domain record create --domain-id ridesharemarket.com --type CNAME --name www --data @`
- `knife digital_ocean domain record create --domain-id ridesharemarket.com --type A --name redline --data 188.166.45.226`
- Update (remove then add)
- `knife digital_ocean domain record list -D ridesharemarket.com`
- Find the ID of the record to remove
- `knife digital_ocean domain record destroy --domain-id ridesharemarket.com --record-id 5563232`
- `knife digital_ocean domain record create --domain-id ridesharemarket.com --type A --name redline --data 188.166.45.226`
