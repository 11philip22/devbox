FROM node:24-bookworm-slim AS codex

ARG CODEX_VERSION=latest

RUN npm install --global "@openai/codex@${CODEX_VERSION}" \
    && npm cache clean --force


FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive

USER root

# Bring Node + Codex CLI over from the Node image.
COPY --from=codex /usr/local/ /usr/local/

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
        unzip \
        yq \
    && rm -rf /var/lib/apt/lists/*

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
    CODEX_HOME=/root/.codex \
    TERM=xterm-256color \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

COPY codex-config.toml /root/.codex/config.toml

WORKDIR /workspace

ENTRYPOINT []
CMD ["codex"]
