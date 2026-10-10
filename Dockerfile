FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG CODEX_VERSION=latest
ARG MAVEN_VERSION=3.10.0
ARG GRADLE_VERSION=9.8.0
ARG CHECKSTYLE_VERSION=14.3.0

USER root

# Dependencies for the language installers.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        openjdk-25-jdk \
        unzip \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/opt/java \
    MAVEN_HOME=/opt/maven \
    GRADLE_HOME=/opt/gradle
ENV PATH=${JAVA_HOME}/bin:${MAVEN_HOME}/bin:${GRADLE_HOME}/bin:${PATH}

RUN ln -s "/usr/lib/jvm/java-25-openjdk-$(dpkg --print-architecture)" "${JAVA_HOME}" \
    && mkdir -p "${MAVEN_HOME}" /opt/checkstyle \
    && curl -fsSL "https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" -o /tmp/maven.tar.gz \
    && curl -fsSL "https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz.sha512" -o /tmp/maven.sha512 \
    && (printf '%s  /tmp/maven.tar.gz\n' "$(cat /tmp/maven.sha512)" | sha512sum -c -) \
    && tar -xzf /tmp/maven.tar.gz --strip-components=1 -C "${MAVEN_HOME}" \
    && curl -fsSL "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" -o /tmp/gradle.zip \
    && curl -fsSL "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip.sha256" -o /tmp/gradle.sha256 \
    && (printf '%s  /tmp/gradle.zip\n' "$(cat /tmp/gradle.sha256)" | sha256sum -c -) \
    && unzip -q /tmp/gradle.zip -d /opt \
    && mv "/opt/gradle-${GRADLE_VERSION}" "${GRADLE_HOME}" \
    && curl -fsSL "https://github.com/checkstyle/checkstyle/releases/download/checkstyle-${CHECKSTYLE_VERSION}/checkstyle-${CHECKSTYLE_VERSION}-all.jar" -o /opt/checkstyle/checkstyle.jar \
    && printf '%s\n' '#!/bin/sh' 'exec "$JAVA_HOME/bin/java" -jar /opt/checkstyle/checkstyle.jar "$@"' > /usr/local/bin/checkstyle \
    && chmod +x /usr/local/bin/checkstyle \
    && rm -f /tmp/maven.tar.gz /tmp/maven.sha512 /tmp/gradle.zip /tmp/gradle.sha256 \
    && java -version \
    && javac -version \
    && mvn --version \
    && gradle --no-daemon --version \
    && checkstyle --version

RUN curl -fsSL https://deb.nodesource.com/setup_24.x -o /tmp/nodesource-setup.sh \
    && bash /tmp/nodesource-setup.sh \
    && apt-get install -y --no-install-recommends nodejs \
    && npm install --global "@openai/codex@${CODEX_VERSION}" \
    && npm cache clean --force \
    && rm -f /tmp/nodesource-setup.sh \
    && rm -rf /var/lib/apt/lists/*

RUN curl --proto '=https' --tlsv1.2 -fsSL https://sh.rustup.rs -o /tmp/rustup-init.sh \
    && sh /tmp/rustup-init.sh -y --no-modify-path --profile minimal --default-toolchain stable \
    --component rustfmt --component clippy \
    --component rust-analyzer --component rust-src \
    && rm -f /tmp/rustup-init.sh

# Changes to this tool list preserve the language installation cache.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        ccache \
        clang \
        clang-format \
        clang-tidy \
        cmake \
        docker-buildx \
        docker-compose-v2 \
        docker.io \
        dotnet-sdk-10.0 \
        gdb \
        gh \
        git \
        git-lfs \
        glab \
        golang-go \
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
        yq \
    && rm -rf /var/lib/apt/lists/* \
    && dotnet --info

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
    PATH=/root/.cargo/bin:/root/.dotnet/tools:/root/go/bin:${PATH} \
    CODEX_HOME=/root/.codex \
    TERM=xterm-256color \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

COPY codex-config.toml /root/.codex/config.toml

WORKDIR /workspace

ENTRYPOINT []
CMD ["codex"]
