## Application Deployment

The application is build with several Docker containers that work together.

- rsm-data
- rsm-api
- rsm-app
- [rsm-nginx](../app/docker/nginx/README.md)
- [rsm-logstash](../app/docker/logstash/README.md)

### Step 1

Build locally and push the application docker images to the local private registry.

### Step 2 (Development VM - Env = vbox)

On the server pull the docker images.

- `for IMAGE (rsm-data:0.0.1 rsm-api:0.0.1 rsm-app:0.0.1 rsm-logstash:0.0.1 rsm-nginx:0.0.1) { ssh vagrant@vbox.ridesharemarket.com sudo docker pull 192.168.33.10:5000/rudijs/$IMAGE }`

On the serer start the containers in order:

- Application
- `ssh vagrant@vbox.ridesharemarket.com sudo docker run -d --restart always --name rsm-data --cap-add SYS_PTRACE --security-opt apparmor:unconfined 192.168.33.10:5000/rudijs/rsm-data:0.0.1`
- `ssh vagrant@vbox.ridesharemarket.com sudo docker run -d --restart always --name rsm-api --env "NODE_ENV=vbx" --cap-add SYS_PTRACE --security-opt apparmor:unconfined 192.168.33.10:5000/rudijs/rsm-api:0.0.1`
- `ssh vagrant@vbox.ridesharemarket.com sudo docker run -d --restart always --name rsm-app --env "NODE_ENV=vbx" --cap-add SYS_PTRACE --security-opt apparmor:unconfined 192.168.33.10:5000/rudijs/rsm-app:0.0.1`
- `ssh vagrant@vbox.ridesharemarket.com sudo docker run -d --restart always --name rsm-nginx --volumes-from rsm-app --link rsm-app:rsm-app --link rsm-api:rsm-api -p 80:80 -p 443:443 192.168.33.10:5000/rudijs/rsm-nginx:0.0.1`
- Logging
- `sudo docker run -d --restart always --name rsm-app-logstash-forwarder --add-host vbox.ridesharemarket.com:192.168.33.10 -v /etc/pki/tls:/etc/pki/tls --volumes-from rsm-app -t 192.168.33.10:5000/rudijs/rsm-logstash-forwarder:0.0.5 '--quiet=true' '--config=/srv/ride-share-market-app/config/rsm-app-logstash-forwarder.json'`
- `ssh vagrant@vbox.ridesharemarket.com sudo docker run -d --restart always --name rsm-logstash --volumes-from rsm-data --volumes-from rsm-api --volumes-from rsm-app 192.168.33.10:5000/rudijs/rsm-logstash:0.0.1`
