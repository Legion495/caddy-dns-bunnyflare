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

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
RUN chmod +x /usr/bin/caddy

EXPOSE 8080 8433

ENTRYPOINT ["caddy"]
CMD ["run", "--config", "/config/Caddyfile"]
