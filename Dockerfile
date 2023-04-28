FROM golang:alpine as builder
RUN apk add --no-cache git
RUN git clone https://github.com/jenningsloy318/redfish_exporter.git /build && cd /build && git checkout e28371ddb8606720b26290df1ee258e350d0f7dd
WORKDIR /build
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-extldflags "-static"' -o main .
FROM scratch
COPY --from=builder /build/main /app/
WORKDIR /app
CMD ["./main"]

