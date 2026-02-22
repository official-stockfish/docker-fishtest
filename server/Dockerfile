FROM ubuntu:22.04

ARG USERNAME=fishtestuser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy
ENV APP_DIR=/app/fishtest

ENV PATH="/home/$USERNAME/.local/bin:$PATH"

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    gnupg \
    nginx \
    pkg-config \
    python3-magic \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/fishtest/nn /etc/nginx/sites-available /etc/nginx/sites-enabled \
    && chown -R $USERNAME:$USERNAME /var/www/fishtest /etc/nginx /var/log/nginx /var/lib/nginx

USER $USERNAME

# Install UV as the non-root user
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

COPY --chown=$USERNAME:$USERNAME nginx.conf /etc/nginx/nginx.conf
COPY --chown=$USERNAME:$USERNAME fishtest.conf /etc/nginx/sites-available/
RUN ln -sf /etc/nginx/sites-available/fishtest.conf /etc/nginx/sites-enabled/fishtest.conf

WORKDIR $APP_DIR

RUN --mount=type=cache,target=/home/$USERNAME/.cache/uv,uid=$USER_UID \
    --mount=type=bind,source=./fishtest/uv.lock,target=uv.lock \
    --mount=type=bind,source=./fishtest/pyproject.toml,target=pyproject.toml \
    uv sync --frozen --no-install-project --no-dev

COPY --chown=$USERNAME:$USERNAME fishtest/uv.lock fishtest/pyproject.toml $APP_DIR/

RUN --mount=type=cache,target=/home/$USERNAME/.cache/uv,uid=$USER_UID \
    uv sync --frozen --no-install-project

COPY --chown=$USERNAME:$USERNAME create_users.py /app/create_users.py
COPY --chown=$USERNAME:$USERNAME .netrc /home/$USERNAME/.netrc
COPY --chown=$USERNAME:$USERNAME entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

RUN ln -sf /app/fishtest/server/fishtest/static /var/www/fishtest/static

EXPOSE 80 6542 6543 6544 6545

ENTRYPOINT []