ARG ALPINE_VERSION=3
ARG GOLANG_VERSION=1.16-alpine

FROM golang:${GOLANG_VERSION} AS builder

ARG TARGETOS
ARG TARGETARCH

WORKDIR /src

RUN apk add --no-cache --no-progress gcc musl-dev git \
    && git clone --depth 1 --branch v1.0 https://github.com/joohoi/acme-dns . \
    && go mod download \
    && CGO_ENABLED=1 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o /out/acme-dns

FROM alpine:${ALPINE_VERSION}

RUN apk --no-cache add ca-certificates musl \
    && mkdir -p /etc/acme-dns \
    && mkdir -p /var/lib/acme-dns
COPY --from=builder /out/acme-dns /usr/local/bin/acme-dns
VOLUME ["/etc/acme-dns", "/var/lib/acme-dns"]
CMD ["acme-dns"]
EXPOSE 53 80 443
EXPOSE 53/udp

LABEL org.opencontainers.image.source="https://github.com/joohoi/acme-dns" \
    org.opencontainers.image.title="acme-dns" \
    org.opencontainers.image.description="A simple DNS server for ACME DNS challenges" \
    org.opencontainers.image.version="v1.0" \
    org.opencontainers.image.documentation="https://github.com/joohoi/acme-dns/blob/master/README.md"
