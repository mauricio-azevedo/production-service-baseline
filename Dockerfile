# syntax=docker/dockerfile:1
# Contract. The runtime stage keeps: non-root user, port 8080, /healthz and /readyz served,
# SIGTERM handled, no build tools in the final image. Fill the build stage for the language.
# Base images are pinned by digest, tag in a comment, for the same reason actions are pinned by SHA.

# alpine:3.22
FROM alpine@sha256:be2656061b536c1883c4034790e21d0a09c5aaaf51968b89368a3c0371ea2c9a AS build
WORKDIR /src
COPY . .
# build here; produce /src/out/app

# alpine:3.22
FROM alpine@sha256:be2656061b536c1883c4034790e21d0a09c5aaaf51968b89368a3c0371ea2c9a
RUN adduser -D -u 10001 app
USER 10001
WORKDIR /app
COPY --from=build /src/out/app /app/app
EXPOSE 8080
ENTRYPOINT ["/app/app"]
