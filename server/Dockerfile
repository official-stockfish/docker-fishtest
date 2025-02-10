FROM ubuntu:22.04

ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy
ENV APP_DIR=/app/fishtest
ENV PATH="/root/.local/bin/:$PATH"

COPY entrypoint.sh /app/entrypoint.sh

RUN chmod +x /app/entrypoint.sh

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    gnupg \
    nginx \
    pkg-config \
    python3-magic \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p $HOME/.local/bin
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Set up nginx configuration
RUN mkdir -p /etc/nginx/sites-available /etc/nginx/sites-enabled /var/www/fishtest/nn
COPY nginx.conf /etc/nginx/nginx.conf
COPY fishtest.conf /etc/nginx/sites-available/
RUN ln -sf /etc/nginx/sites-available/fishtest.conf /etc/nginx/sites-enabled/fishtest.conf

# Create required secret files
RUN echo "your-secret-key-here" > /root/fishtest.secret \
    && echo "your-captcha-secret-here" > /root/fishtest.captcha.secret \
    && chmod 600 /root/fishtest.secret /root/fishtest.captcha.secret


# Set up working directory
WORKDIR $APP_DIR

RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=./fishtest/uv.lock,target=uv.lock \
    --mount=type=bind,source=./fishtest/pyproject.toml,target=pyproject.toml \
    uv sync --frozen --no-install-project --no-dev

ADD ./fishtest $APP_DIR

RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev

COPY create_users.py /app/create_users.py
COPY .netrc /root/.netrc

# Create symlink for static files
RUN ln -sf /app/fishtest/server/fishtest/static /var/www/fishtest/static

# Expose ports
EXPOSE 80 6542 6543 6544 6545

# Reset entrypoint
ENTRYPOINT []