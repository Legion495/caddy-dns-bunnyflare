FROM caddy:builder AS builder

# Added modules:
#   - Cloudflare  : github.com/caddy-dns/cloudflare
#   - BunnyCDN   : github.com/caddy-dns/bunny
#
# xcaddy builder
RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/caddy-dns/bunny \
    --output /usr/bin/caddy

FROM caddy:alpine

# Create caddy user and group
RUN addgroup -S caddy && \
    adduser -S caddy -G caddy

# Create and set permissions for /config
RUN mkdir -p /config && \
    chown -R caddy:caddy /config

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
RUN chmod +x /usr/bin/caddy

# Set /config as the working directory
WORKDIR /config

EXPOSE 8080 8433

USER caddy

ENTRYPOINT ["caddy"]
CMD ["run", "--config", "/etc/caddy/Caddyfile"]
