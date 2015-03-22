To list all images in the private registry:

- `curl -s 192.168.33.10:5000/v1/search`
- `curl -s 192.168.33.10:5000/v1/search | ~/bin/jq .`

To list all tags for a given image in the private registry:

- `curl -s 192.168.33.10:5000/v1/repositories/YOUR_IMAGE/tags`
- `curl -s 192.168.33.10:5000/v1/repositories/rudijs/rsm-nginx/tags`
- `curl -s 192.168.33.10:5000/v1/repositories/rudijs/rsm-nginx/tags | ~/bin/jq .`

To delete an image from the private registry.

- `curl -X DELETE 192.168.33.10:5000/v1/repositories/rudijs/rsm-nginx/tags/x.x.x`
