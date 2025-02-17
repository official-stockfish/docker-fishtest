FROM ubuntu:24.04

RUN apt update && apt upgrade -y && apt install -y \
  git vim python3 make g++ \
  curl wget

# for clang builds, install: clang llvm

RUN useradd --create-home --shell /bin/bash worker

WORKDIR /home/worker
COPY run_workers.sh .
RUN chmod +x run_workers.sh

USER worker
ENV NUM_WORKERS ${NUM_WORKERS}
ENV WORKER_CONFIG $WORKER_CONFIG

CMD ["./run_workers.sh"]
