FROM golang:1.14-alpine AS build

WORKDIR /src/
COPY main.go go.* /src/
RUN CGO_ENABLED=0 go build -o /bin/poddebugger

FROM alpine
WORKDIR /go
EXPOSE 3000
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
COPY --from=build /bin/poddebugger /go/poddebugger
ENTRYPOINT ["/go/poddebugger"]
