#!/bin/sh

set -eux

start_dockerd(){
    dockerd > /var/log/dockerd.log 2>&1 &
    sleep 2 # TODO replace by while ...
}

main(){
	start_dockerd
	exec "$@" #TODO, not sure about it, and systemd
}

main "$@"
