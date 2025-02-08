FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    gnupg \
    nginx \
    pkg-config \
    python3 \
    python3-pip \
    python3-venv \
    python3-magic \
    && rm -rf /var/lib/apt/lists/*

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
WORKDIR /app/fishtest/server

COPY create_users.py /app/create_users.py

# Install Python dependencies
RUN pip3 install --no-cache-dir pyramid pymongo pytest
RUN pip3 install --user --no-cache-dir \
    pyramid \
    pyramid_debugtoolbar \
    waitress \
    pymongo \
    pyramid_mako \
    python-magic \
    email_validator \
    numpy \
    scipy \
    awscli \
    vtjson \
    zxcvbn

# Create symlink for static files
RUN ln -sf /app/fishtest/server/fishtest/static /var/www/fishtest/static

# Expose ports
EXPOSE 80 6542 6543 6544 6545

