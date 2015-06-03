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

On the server start the containers in order:

- Node Apps
- `sudo docker run -d --restart always --name rsm-data --cap-add SYS_PTRACE --security-opt apparmor:unconfined 192.168.33.10:5000/rudijs/rsm-data:0.0.9`
- `sudo docker run -d --restart always --name rsm-api --env "NODE_ENV=vbx" --add-host met01.dev.vbx.ridesharemarket.com:192.168.33.10 --cap-add SYS_PTRACE --security-opt apparmor:unconfined 192.168.33.10:5000/rudijs/rsm-api:0.0.33`
- `sudo docker run -d --restart always --name rsm-api-logstash-forwarder --add-host vbox.ridesharemarket.com:192.168.33.10 -v /etc/pki/tls:/etc/pki/tls --volumes-from rsm-api -t 192.168.33.10:5000/rudijs/rsm-logstash-forwarder:0.0.6 '--quiet=true' '--config=/srv/ride-share-market-api/config/logstash-forwarder.json'`
- `sudo docker run -d --restart always --name rsm-app --env "NODE_ENV=vbx" --cap-add SYS_PTRACE --security-opt apparmor:unconfined 192.168.33.10:5000/rudijs/rsm-app:0.0.54`
- `sudo docker run -d --restart always --name rsm-app-logstash-forwarder --add-host vbox.ridesharemarket.com:192.168.33.10 -v /etc/pki/tls:/etc/pki/tls --volumes-from rsm-app -t 192.168.33.10:5000/rudijs/rsm-logstash-forwarder:0.0.6 '--quiet=true' '--config=/srv/ride-share-market-app/config/rsm-app-logstash-forwarder.json'`
- NGINX
- `sudo docker run -d --restart always --name rsm-nginx --volumes-from rsm-app --link rsm-app:rsm-app --link rsm-api:rsm-api -p 80:80 -p 443:443 192.168.33.10:5000/rudijs/rsm-nginx:0.0.31`

- Remove RSM Application
- `for CONTAINER in 'rsm-nginx rsm-api-logstash-forwarder rsm-api rsm-app-logstash-forwarder rsm-app rsm-data'; do sudo docker rm -f -v $CONTAINER; done`


192.168.33.10:5000/rudijs/rsm-data:0.0.9
192.168.33.10:5000/rudijs/rsm-api:0.0.33
192.168.33.10:5000/rudijs/rsm-logstash-forwarder:0.0.6
192.168.33.10:5000/rudijs/rsm-app:0.0.54
192.168.33.10:5000/rudijs/rsm-logstash-forwarder:0.0.6
192.168.33.10:5000/rudijs/rsm-nginx:0.0.31