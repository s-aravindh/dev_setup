#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# code-server password — set the PASSWORD env var in RunPod's template
# settings; falls back to "changeme" so the container always starts.
# ---------------------------------------------------------------------------
export PASSWORD="${PASSWORD:-changeme}"

# ---------------------------------------------------------------------------
# Install VS Code extensions on first boot (skipped on subsequent starts).
# Done here instead of during docker build to avoid QEMU/Rosetta failures
# when building the image on Apple Silicon.
# ---------------------------------------------------------------------------
EXTENSIONS_STAMP="/root/.local/share/code-server/.extensions-installed"
if [[ ! -f "$EXTENSIONS_STAMP" ]]; then
    echo "Installing VS Code extensions (first boot)..."
    code-server --install-extension ms-python.python     \
                --install-extension ms-python.pylance     \
                --install-extension charliermarsh.ruff    \
                --install-extension ms-toolsai.jupyter    \
                --install-extension eamodio.gitlens
    touch "$EXTENSIONS_STAMP"
    echo "Extensions installed."
fi

echo "Starting code-server on 0.0.0.0:8080  (workspace: /workspace)"

exec code-server \
    --bind-addr 0.0.0.0:8080 \
    --auth password \
    /workspace
