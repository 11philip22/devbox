<div align="center">

# Devbox

![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![C](https://img.shields.io/badge/C-00599C?style=for-the-badge&logo=c&logoColor=white)
![C++](https://img.shields.io/badge/C%2B%2B-00599C?style=for-the-badge&logo=cplusplus&logoColor=white)
![Rust](https://img.shields.io/badge/Rust-000000?style=for-the-badge&logo=rust&logoColor=white)

An Ubuntu 24.04 development container for Python, C, C++, and Rust, with Codex CLI and the tools to build, debug, and check your code.

</div>

## Run

```powershell
docker pull philipwold/devbox:latest
docker run --rm -it --init -v codex-home:/root/.codex -v "${PWD}:/workspace" philipwold/devbox:latest
```

## Tools

### Generic

- Codex CLI
- Node.js 24 and npm
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
