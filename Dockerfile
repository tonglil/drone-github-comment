# Docker image for the Drone GH PR Comment plugin
#
#     docker build -t tonglil/drone-github-comment .

#
# Build binary
#

FROM golang:alpine AS builder

ENV CGO_ENABLED=0

ARG VERSION
ARG SHA

# set working directory
RUN mkdir -p /go/src/github.com/tonglil/drone-github-comment
WORKDIR /go/src/github.com/tonglil/drone-github-comment

# copy sources
COPY . .

# build binary
RUN go build -ldflags "-X main.revision=${VERSION:-none}-${SHA:-none}" -o "/drone-github-comment"

#
# Build the image
#

FROM alpine

RUN apk update && \
  apk add \
    ca-certificates && \
  rm -rf /var/cache/apk/*

COPY --from=builder /drone-github-comment /bin/drone-github-comment

ENTRYPOINT ["/bin/drone-github-comment"]
