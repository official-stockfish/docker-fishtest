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