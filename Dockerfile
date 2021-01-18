FROM        golang:1.15.0 as gobuild
MAINTAINER  kirin13 <kirin13@163.com>

RUN mkdir /kafka_exporter
WORKDIR /kafka_exporter
COPY . .
RUN make build

FROM alpine:3.12
MAINTAINER kirin13 <kirin13@163.com>
WORKDIR /
COPY --from=gobuild /kafka_exporter/kafka_exporter /usr/local/bin/
RUN apk update \
    && apk upgrade \
    && apk add --no-cache \
    ca-certificates \
    && update-ca-certificates 2>/dev/null || true

EXPOSE     9308
ENTRYPOINT ["/usr/local/bin/kafka_exporter"]