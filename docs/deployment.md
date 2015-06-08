## Application Deployment

The application is build with several Docker containers that work together.

- rsm-data
- rsm-api
- rsm-app
- [rsm-nginx](../app/docker/nginx/README.md)
- [rsm-logstash-forwarder](../app/docker/logstash-forwarder/README.md)

### Step 1

Build locally and push the application docker images to the local private registry.

### Step 2

### Local Developer Machine

The docker images and container names to be used for deployment are stored in a JSON file.

Update [rsm.json](../app/kitchen/data_bags/docker/rsm.json) to the required versions.

On the Remote server:
 
1. Pull down the images from the local docker registry.
2. Remove any running containers in order.
3. Start containers in order.

These steps are handled using Capistrano

- `cd app`
- Virtual Machine (local)
- `bundle exec cap vbx docker_deploy`
