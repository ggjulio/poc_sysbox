FROM alpine:3.17

RUN apk update \
	&& apk add docker
## add ant, maven, java, node, python ?
# TODO add systemd

COPY docker-pull.sh /usr/bin/

RUN docker-pull.sh \
		alpine:3.17 \
		busybox:1.36.0 \
	&& rm /usr/bin/docker-pull.sh
