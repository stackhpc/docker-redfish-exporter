FROM golang:alpine as builder
RUN apk add --no-cache git
RUN git clone https://github.com/jovial/redfish_exporter /build && cd /build && git checkout 59d1061fb0370cf72e1f813dfcc425f139be49d7
WORKDIR /build
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-extldflags "-static"' -o main .
FROM scratch
COPY --from=builder /build/main /app/
WORKDIR /app
CMD ["./main"]

