#!/bin/sh

set -eux

start_dockerd(){
    dockerd > /var/log/dockerd.log 2>&1 &
    sleep 4
}

#
stop_dockerd(){
    kill "$(cat /var/run/docker.pid)" \
        "$(cat /run/docker/containerd/containerd.pid)"
    rm -f /var/run/docker.pid \
        /run/docker/containerd/containerd.pid
}

# Pull inner images for caching
docker_pull_inner_images(){
    docker pull alpine:3.17
    docker pull busybox:1.36.0
    
    # shellcheck disable=SC2068
    for image in $@
    do
        echo Pulling image "${image}"
        docker pull "${image}"
    done
}

main(){
    start_dockerd
    docker_pull_inner_images "$@"
    stop_dockerd
}

main "$@"