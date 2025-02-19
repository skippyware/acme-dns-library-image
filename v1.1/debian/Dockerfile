ARG DEBIAN_VERSION=bookworm-slim
ARG GOLANG_VERSION=1.23-alpine

FROM --platform=${BUILDPLATFORM} golang:${GOLANG_VERSION} AS builder

ARG TARGETOS
ARG TARGETARCH

WORKDIR /src

RUN apk add --no-cache --no-progress gcc musl-dev git \
    && git clone --depth 1 --branch v1.1 https://github.com/joohoi/acme-dns . \
    && ls -la

RUN go mod download \
    && GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o /out/acme-dns

FROM debian:${DEBIAN_VERSION}

RUN apt-get update -q \
    && apt-get install -yq ca-certificates \
    && mkdir -p /etc/acme-dns \
    && mkdir -p /var/lib/acme-dns \
    && rm -rf /var/cache/apt/archives /var/lib/apt/lists/*
COPY --from=builder /out/acme-dns /usr/local/bin/acme-dns
VOLUME ["/etc/acme-dns", "/var/lib/acme-dns"]
CMD ["acme-dns"]
EXPOSE 53 80 443
EXPOSE 53/udp

LABEL org.opencontainers.image.source="https://github.com/joohoi/acme-dns" \
    org.opencontainers.image.title="acme-dns" \
    org.opencontainers.image.description="A simple DNS server for ACME DNS challenges" \
    org.opencontainers.image.version="v1.1" \
    org.opencontainers.image.documentation="https://github.com/joohoi/acme-dns/blob/master/README.md"
