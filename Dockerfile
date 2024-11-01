FROM golang:1.21.13 AS builder

ARG VERSION
ENV PKG github.com/clcc2019/kubernetes-event-exporter/pkg

ADD . /app
WORKDIR /app
RUN go get
RUN CGO_ENABLED=0 GOOS=linux GO11MODULE=on go build -ldflags="-s -w -X ${PKG}/version.Version=${VERSION}" -a -o /main .

FROM gcr.io/distroless/base-debian12:nonroot
COPY --from=builder /main /kubernetes-event-exporter

# https://github.com/GoogleContainerTools/distroless/blob/main/base/base.bzl#L8C1-L9C1
USER 65532

ENTRYPOINT ["/kubernetes-event-exporter"]
