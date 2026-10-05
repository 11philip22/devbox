FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG CODEX_VERSION=latest

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        ccache \
        clang \
        clang-format \
        clang-tidy \
        cmake \
        curl \
        gdb \
        gh \
        git \
        git-lfs \
        glab \
        jq \
        less \
        libffi-dev \
        libssl-dev \
        lld \
        ninja-build \
        openssh-client \
        pipx \
        pkg-config \
        procps \
        python3 \
        python3-dev \
        python3-pip \
        python3-venv \
        ripgrep \
        rustup \
        unzip \
        yq \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deb.nodesource.com/setup_24.x -o /tmp/nodesource-setup.sh \
    && bash /tmp/nodesource-setup.sh \
    && apt-get install -y --no-install-recommends nodejs \
    && npm install --global "@openai/codex@${CODEX_VERSION}" \
    && npm cache clean --force \
    && rm -f /tmp/nodesource-setup.sh \
    && rm -rf /var/lib/apt/lists/*

RUN rustup toolchain install stable --profile minimal \
    --component rustfmt --component clippy \
    --component rust-analyzer --component rust-src \
    && rustup default stable

# Global developer tools.
# Project dependencies still belong in each project's .venv.
ENV PIPX_HOME=/opt/pipx \
    PIPX_BIN_DIR=/usr/local/bin

RUN pipx install mypy \
    && pipx install ruff \
    && pipx install ipython

# Codex state/auth lives here, making it easy to persist later if desired.
RUN mkdir -p /root/.codex /workspace

ENV HOME=/root \
    PATH=/root/.cargo/bin:${PATH} \
    CODEX_HOME=/root/.codex \
    TERM=xterm-256color \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

COPY codex-config.toml /root/.codex/config.toml

WORKDIR /workspace

ENTRYPOINT []
CMD ["codex"]
