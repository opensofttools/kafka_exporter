FROM        golang:1.15.0 as gobuild
MAINTAINER  kirin13 <kirin13@163.com>

RUN mkdir /tools
WORKDIR /tools
COPY go.mod .
COPY go.sum .
RUN go mod download
COPY . .
RUN make

FROM alpine:3.12
MAINTAINER kirin13 <kirin13@163.com>
WORKDIR /
COPY --from=gobuild /tools/kafka_exporter /
RUN apk update \
    && apk upgrade \
    && apk add --no-cache \
    ca-certificates \
    && update-ca-certificates 2>/dev/null || true

EXPOSE     9308
ENTRYPOINT ["/kafka_exporter"]