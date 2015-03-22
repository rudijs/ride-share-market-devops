## Development

Build locally and run for testing.

- `sudo docker build -t rudijs/rsm-logstash:x.x.x .`
- `sudo docker run -d --name rsm-logstash -t rudijs/rsm-logstash:x.x.x`

## Deployment

Build docker image locally, tag it, push it to the private docker registry.

- `./docker-build.sh x.x.x`

Deploy on remote server.

- `sudo docker pull 192.168.33.10:5000/rudijs/rsm-logstash:x.x.x`
- Initial.
- `sudo docker run -d --restart always -d --name rsm-logstash --volumes-from rsm-data --volumes-from rsm-api --volumes-from rsm-app 192.168.33.10:5000/rudijs/rsm-logstash:x.x.x`
- Replace existing container.
- `sudo docker rm -f -v rsm-logstash && sudo docker run -d --restart always -d --name rsm-logstash --volumes-from rsm-data --volumes-from rsm-api --volumes-from rsm-app 192.168.33.10:5000/rudijs/rsm-logstash:x.x.x`
