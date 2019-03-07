FROM alpine:latest
MAINTAINER Nick Pratley <nick@npratley.net>

ENV CADDY_FEATURES="dns,dyndns,hook.service,http.authz,http.awses,http.awslambda,http.cache,http.cgi,http.cors,http.datadog,http.expires,http.filebrowser,http.filter,http.forwardproxy,http.geoip,http.git,http.gopkg,http.grpc,http.ipfilter,http.jwt,http.locale,http.login,http.mailout,http.minify,http.nobots,http.prometheus,http.proxyprotocol,http.ratelimit,http.realip,http.reauth,http.restic,http.s3browser,http.supervisor,http.upload,http.webdav,net,supervisor,tls.dns.cloudflare"

COPY files/run.sh /caddy-bootstrap/run.sh

RUN apk --update add \
	curl \
	openssh-client \
	git \
	tar \
	ca-certificates \
	shadow \
 && curl --silent --show-error --fail --location \
      --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
      "https://caddyserver.com/download/linux/amd64?plugins=${CADDY_FEATURES}&license=personal&telemetry=off" \
    | tar --no-same-owner -C /usr/bin/ -xz caddy \
 && chmod 0755 /usr/bin/caddy \
 && mkdir /caddy-bootstrap/pre-run/ \
 && rm -rf /var/cache/apk/*

WORKDIR /www
ENTRYPOINT ["/caddy-bootstrap/run.sh"]
