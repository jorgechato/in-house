FROM golang:1.21-rc-alpine as builder

RUN apk add -U --no-cache git ca-certificates tzdata

COPY . /app
WORKDIR /app

RUN go mod download
RUN go mod verify

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -ldflags="${LDFLAGS}" -o server main.go


FROM scratch as final

ENV GIN_MODE=release

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=builder /app/server /opt/server

ENTRYPOINT ["/opt/server"]