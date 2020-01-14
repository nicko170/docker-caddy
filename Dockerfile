FROM alpine:latest
MAINTAINER Nick Pratley <nick@npratley.net>

LABEL caddy_version="0.8.2" architecture="amd64"

RUN apk add --update openssh-client git tar curl

RUN mkdir /caddysrc \
&& curl -sL -o /caddysrc/caddy_linux_amd64.tar.gz "https://caddyserver.com/download/linux/amd64?plugins=hook.service,http.forwardproxy,http.git,http.minify,http.prometheus,http.realip,tls.dns.cloudflare&license=personal&telemetry=off" \
&& tar -xf /caddysrc/caddy_linux_amd64.tar.gz -C /caddysrc \
&& mv /caddysrc/caddy /usr/bin/caddy \
&& chmod 755 /usr/bin/caddy \
&& rm -rf /caddysrc \
&& printf "0.0.0.0\nfastcgi / phpfpm:9000 php\nbrowse\nstartup php-fpm" > /etc/Caddyfile

EXPOSE 443
EXPOSE 80

WORKDIR /srv

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["-agree", "--conf", "/etc/Caddyfile"]

