# Multistage Go build
FROM golang:1.19.2-alpine3.16 AS builder
RUN apk add --no-cache git
WORKDIR /go/src/github.com/mkm29/api-gateway/
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -o app cmd/main.go

# Final image
LABEL maintainer="Mitch Murphy <mitch.murphy@gmail.com>" \
  version="0.1.0" \
  description="API Gateway for Go gRPC demo"
FROM alpine:3.16
COPY --from=builder /go/src/github.com/mkm29/api-gateway/app /app
EXPOSE 3000
ENTRYPOINT ["/app"]