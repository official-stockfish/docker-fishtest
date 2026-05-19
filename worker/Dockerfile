FROM alpine:edge

# base system + tools
RUN apk update && apk add --no-cache \
    bash \
    git \
    vim \
    python3 \
    py3-pip \
    make \
    gcc \
    g++ \
    musl-dev \
    curl \
    wget \
    clang \
    llvm \
    shadow \
    su-exec

# updater stays as root
COPY updater.sh /updater.sh
RUN chmod +x /updater.sh

# install gosu for the current architecture
ENV GOSU_VERSION=1.19

RUN set -eux; \
    arch="$(apk --print-arch)"; \
    case "$arch" in \
        x86_64) gosu_arch='amd64' ;; \
        aarch64) gosu_arch='arm64' ;; \
        *) echo "unsupported architecture: $arch"; exit 1 ;; \
    esac; \
    curl -Lo /usr/local/bin/gosu \
      "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-${gosu_arch}"; \
    chmod +x /usr/local/bin/gosu; \
    gosu nobody true

# make worker user
RUN useradd -m -s /bin/bash worker

WORKDIR /home/worker

COPY run_workers.sh .
RUN chmod +x run_workers.sh

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV NUM_WORKERS=""
ENV WORKER_CONFIG=""

# run updater in background and then start your workers
ENTRYPOINT ["/entrypoint.sh"]
CMD ["./run_workers.sh"]
