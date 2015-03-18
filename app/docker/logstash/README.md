## Dev box

Build locally and run for testing.

- `sudo docker build -t rudijs/rsm-logstash:0.0.1 .`
- `sudo docker run -d --name rsm-logstash -v /tmp/log:/srv/ride-share-market-data/log -t rudijs/rsm-logstash:0.0.1`

Build docker image locally, tag it, push it to the private docker registry.

- `./docker-build.sh 0.0.2`

## VM box

Deploy on remote server.

- `sudo docker pull 192.168.33.10:5000/rudijs/rsm-logstash:0.0.2`
- `sudo docker rm -f rsm-logstash && sudo docker run -d --restart always -d --name rsm-logstash -v /srv/ride-share-market-data/log:/srv/ride-share-market-data/log -v /srv/ride-share-market-api/log:/srv/ride-share-market-api/log -v /srv/ride-share-market-app/log:/srv/ride-share-market-app/log 192.168.33.10:5000/rudijs/rsm-logstash:0.0.2`
