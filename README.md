# Devbox

## Tools

- Codex CLI
- Node.js 24 and npm
- Python 3, pip, venv, and pipx
- mypy, Ruff, pre-commit, and IPython
- GCC, G++, Make, and pkg-config
- Git and OpenSSH client
- curl, jq, ripgrep, unzip, less, and procps

## Run

```powershell
docker pull philipwold/devbox:latest
docker run --rm -it --init -v codex-home:/root/.codex -v "${PWD}:/workspace" philipwold/devbox:latest
```
