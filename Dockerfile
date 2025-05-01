FROM golang:1.21 AS builder

LABEL maintainer="Jennings Liu <jenningsloy318@gmail.com>"

ARG ARCH=amd64

# Build binary
RUN mkdir -p /go/src/github.com/ && \
    git clone https://github.com/stackhpc/redfish_exporter /go/src/github.com/stackhpc/redfish_exporter && \
    cd /go/src/github.com/stackhpc/redfish_exporter && \
    git checkout d963088baa0fd477878d7263d15f8507624c3172 && \
    make build

FROM golang:1.21

COPY --from=builder /go/src/github.com/stackhpc/redfish_exporter/build/redfish_exporter /usr/local/bin/redfish_exporter
RUN mkdir /etc/prometheus
COPY --from=builder /go/src/github.com/stackhpc/redfish_exporter/config.yml.example /etc/prometheus/redfish_exporter.yml
CMD ["/usr/local/bin/redfish_exporter","--config.file","/etc/prometheus/redfish_exporter.yml"]
