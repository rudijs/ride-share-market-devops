## Install

[Developer Workstation](install_developer_workstation.md)

[Remote Server: Private Registry](registry/README.md)

## Usage

To list all images in the private registry:

- `curl -s 192.168.33.10:5000/v1/search`
- `curl -s 192.168.33.10:5000/v1/search | ~/bin/jq .`

To list all tags for a given image in the private registry:

- `curl -s 192.168.33.10:5000/v1/repositories/YOUR_IMAGE/tags`
- `curl -s 192.168.33.10:5000/v1/repositories/rudijs/rsm-nginx/tags`
- `curl -s 192.168.33.10:5000/v1/repositories/rudijs/rsm-nginx/tags | ~/bin/jq .`

To delete an image from the private registry.

- `curl -X DELETE 192.168.33.10:5000/v1/repositories/rudijs/rsm-nginx/tags/x.x.x`

Fire up a quick container that will remove itself up on close.

- `sudo docker run -i -t --rm ubuntu:14.04 /bin/bash`

