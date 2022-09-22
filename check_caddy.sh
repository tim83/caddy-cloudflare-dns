#! /bin/bash

BASE_IMAGE="docker.io/library/caddy"
NEW_IMAGE="docker.io/tim83/caddy-cloudflare"

lookup_latest_version () {
    podman pull "$1:latest" > /dev/null
    podman inspect "$1:latest" | jq '.[0].Labels."org.opencontainers.image.version"'
}

latest_base_version=$(lookup_latest_version "$BASE_IMAGE")
latest_new_version=$(lookup_latest_version "$NEW_IMAGE")

if [ $latest_base_version != $latest_new_version ] ; then
    python3 -m timtools.notify --text "Een nieuwe versie van caddy is beschikbaar ($latest_base_version)"
    cd ~/Programs/docker/caddy-cloudflare
    new_version=$(echo $latest_base_version | sed s/[\",v]//g)
    sed -i "s/basetag=.*/basetag=$new_version/" Dockerfile
    git add Dockerfile
    git commit -m "Update caddy to ${latest_base_version}"
    git push
fi