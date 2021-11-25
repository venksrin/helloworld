FROM golang:1.8-alpine
ADD . /go/src/venky-hello-world
RUN go install venky-hello-world

FROM alpine:latest
COPY --from=0 /go/bin/venky-hello-world .
ENV PORT 8080
CMD ["./venky-hello-world"]
