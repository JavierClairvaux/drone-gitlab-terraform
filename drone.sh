#!/bin/bash
sudo systemctl stop httpd
sudo systemctl disable httpd

docker run \
  --volume=/var/lib/drone:/data \
  --env=DRONE_GITLAB_SERVER=https://gitlab.com \
  --env=DRONE_GITLAB_CLIENT_ID="${drone_gitlab_client_id}" \
  --env=DRONE_GITLAB_CLIENT_SECRET="${drone_gitlab_secret_id}" \
  --env=DRONE_RPC_SECRET="${drone_rpc_secret}" \
  --env=DRONE_SERVER_HOST="${drone_host}" \
  --env=DRONE_SERVER_PROTO=https \
  --env=DRONE_TLS_AUTOCERT=true \
  --publish=80:80 \
  --publish=443:443 \
  --restart=always \
  --detach=true \
  --name=drone \
  drone/drone:1

docker run -d \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e DRONE_RPC_PROTO=https \
  -e DRONE_RPC_HOST="${drone_host}" \
  -e DRONE_RPC_SECRET="${drone_rpc_secret}" \
  -e DRONE_RUNNER_CAPACITY=2 \
  -e DRONE_RUNNER_NAME=$HOSTNAME \
  -p 3000:3000 \
  --restart always \
  --name runner \
  drone/drone-runner-docker:1

