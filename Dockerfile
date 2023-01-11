ARG basetag=latest
ARG buildertag=builder

FROM caddy:${buildertag} AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/abiosoft/caddy-exec

FROM caddy:${basetag}

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
