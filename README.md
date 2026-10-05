<div align="center">

# Devbox

[![Python, C, C++, Rust, JavaScript, TypeScript, Java](https://skillicons.dev/icons?i=python,c,cpp,rust,js,ts,java)](https://skillicons.dev/)

An Ubuntu 24.04 development container with Codex CLI and the tools to build, debug, and check your code.

</div>

## Run

```powershell
docker pull philipwold/devbox:latest
docker run --rm -it --init -v codex-home:/root/.codex -v "${PWD}:/workspace" philipwold/devbox:latest
```

## Tools

### Generic

- Codex CLI
- Git, Git LFS, and OpenSSH client
- GitHub CLI (`gh`) and GitLab CLI (`glab`)
- curl, jq, yq, ripgrep, unzip, less, and procps

### Python

- Python 3, pip, venv, and pipx
- mypy, Ruff, and IPython

### C/C++

- GCC, G++, Clang, Make, CMake, Ninja, and pkg-config
- GDB, clang-format, and clang-tidy
- ccache and lld

### Rust

- rustup, rustc, and Cargo
- rustfmt and Clippy
- rust-analyzer

### JavaScript and TypeScript

- Node.js 24 and npm

### Java

- OpenJDK 25 LTS
- Maven and Gradle
- jdb
- jcmd, jstack, jmap, and jconsole
- Checkstyle
