## Private Docker Registry

## Install

- `sudo docker pull registry`

## Start

- `sudo docker run -d --restart always --name rsm-registry -p 5000:5000 registry`

## Web UI

- [docker-registry-frontend](https://github.com/kwk/docker-registry-frontend)
- `sudo docker pull konradkleine/docker-registry-frontend`
- `sudo docker run -d --restart always --name rsm-docker-registry-ui -e ENV_DOCKER_REGISTRY_HOST=192.168.33.10 -e ENV_DOCKER_REGISTRY_PORT=5000 -p 9001:80 konradkleine/docker-registry-frontend`
- [http://vbox.ridesharemarket.com:9001](http://vbox.ridesharemarket.com:9001)
