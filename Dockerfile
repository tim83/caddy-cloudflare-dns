ARG basetag=2.5.2
ARG buildertag=${basetag}-builder

FROM caddy:${buildertag} AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare

FROM caddy:${basetag}

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
