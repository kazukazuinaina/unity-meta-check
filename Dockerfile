FROM golang:1.16-buster as builder
WORKDIR /go/src/unity-meta-check
COPY . .
RUN make linux-amd64 && \
	mv ./dist/unity-meta-check-linux-amd64 ./dist/unity-meta-check && \
	mv ./dist/unity-meta-check-junit-linux-amd64 ./dist/unity-meta-check-junit && \
	mv ./dist/unity-meta-check-github-pr-comment-linux-amd64 ./dist/unity-meta-check-github-pr-comment && \
	mv ./dist/unity-meta-autofix-linux-amd64 ./dist/unity-meta-autofix

FROM debian:buster-slim
RUN apt-get update \
	&& apt-get install --yes --no-install-recommends git \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*
COPY --from=builder /go/src/unity-meta-check/dist/* /usr/bin/
ENTRYPOINT ["unity-meta-check"]
CMD ["-help"]
