ARG DEBIAN_VERSION=bookworm-slim
ARG GOLANG_VERSION=1.23-bookworm

FROM golang:${GOLANG_VERSION} AS builder

ARG TARGETOS
ARG TARGETARCH

WORKDIR /src

RUN apt-get update -q \
    && apt-get install -yq gcc build-essential libc6-dev git \
    && git clone --depth 1 --branch v1.1 https://github.com/joohoi/acme-dns . \
    && go mod download \
    && CGO_ENABLED=1 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o /out/acme-dns \
    && rm -rf /var/cache/apt/archives /var/lib/apt/lists/*

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
