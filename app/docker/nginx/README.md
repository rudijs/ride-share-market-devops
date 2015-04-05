## Development

Build locally and run for testing.

- `sudo docker build -t rudijs/rsm-nginx:x.x.x .`
- `sudo docker run -d --name rsm-nginx --volumes-from rsm-app -p 80:80 -t rudijs/rsm-nginx:x.x.x`
- `sudo docker rm -f -v rsm-nginx && sudo docker run -d --name rsm-nginx --volumes-from rsm-app -p 80:80 -t rudijs/rsm-nginx:x.x.x`

## Build and Deploy

Build docker image locally, tag it, push it to the private docker registry.

- `./docker-build.sh x.x.x`

Deploy on remote server.

- `sudo docker pull 192.168.33.10:5000/rudijs/rsm-nginx:x.x.x`
- Initial.
- `sudo docker run -d --restart always --name rsm-nginx --volumes-from rsm-app --link rsm-app:rsm-app -p 80:80 192.168.33.10:5000/rudijs/rsm-nginx:x.x.x`
- Replace running container.
- `sudo docker rm -f -v rsm-nginx && sudo docker run -d --restart always --name rsm-nginx --volumes-from rsm-app --link rsm-app:rsm-app -p 80:80 192.168.33.10:5000/rudijs/rsm-nginx:x.x.x`
