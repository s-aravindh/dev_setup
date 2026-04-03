# ---------------------------------------------------------------------------
# RunPod Dev Template — code-server + Python + uv + PyTorch + vLLM (CUDA 13)
#
# NOTE: If nvidia/cuda:13.0.0 is not yet available on Docker Hub,
#       pass a different version at build time:
#         docker build --build-arg CUDA_VERSION=12.6.3 ...
# ---------------------------------------------------------------------------
ARG CUDA_VERSION=13.0.0
# Force linux/amd64 so the build works on Apple Silicon (ARM) without Rosetta failures.
# Using ARG to silence the FromPlatformFlagConstDisallowed lint warning.
ARG BUILD_PLATFORM=linux/amd64
FROM --platform=${BUILD_PLATFORM} nvidia/cuda:${CUDA_VERSION}-cudnn-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PATH="/root/.local/bin:$PATH"

# ---------------------------------------------------------------------------
# 1. System packages
# ---------------------------------------------------------------------------
RUN apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common ca-certificates curl \
    # Enable universe repo for nvtop
    && add-apt-repository -y universe \
    # Add GitHub CLI apt repo
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
        > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update && apt-get install -y --no-install-recommends \
        python3.11 \
        python3.11-dev \
        python3-pip \
        wget \
        git \
        build-essential \
        # ML system tools
        ffmpeg \
        tmux \
        htop \
        nvtop \
        vim \
        jq \
        unzip \
        rsync \
        gh \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1 \
    && update-alternatives --install /usr/bin/python  python  /usr/bin/python3.11 1 \
    && rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------------------------------
# 2. uv — fast Python package manager
# ---------------------------------------------------------------------------
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# ---------------------------------------------------------------------------
# 3. code-server (VS Code in the browser)
#    Download the .deb directly with retries — avoids flaky SSL issues that
#    occur when using the install.sh pipe-to-sh approach during Docker builds.
# ---------------------------------------------------------------------------
ARG CODE_SERVER_VERSION=4.113.0
RUN curl -fSL --retry 5 --retry-delay 5 --retry-all-errors \
        -o /tmp/code-server.deb \
        "https://github.com/coder/code-server/releases/download/v${CODE_SERVER_VERSION}/code-server_${CODE_SERVER_VERSION}_amd64.deb" \
    && dpkg -i /tmp/code-server.deb \
    && rm /tmp/code-server.deb

# ---------------------------------------------------------------------------
# 4. VS Code extensions are installed at container startup (entrypoint.sh)
#    to avoid QEMU/Rosetta failures when building on Apple Silicon.
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# 5. PyTorch with CUDA 13 support
#    If cu130 wheels are unavailable, change the index URL to cu124 / cu121.
# ---------------------------------------------------------------------------
RUN uv pip install --system \
        torch \
        torchvision \
        torchaudio \
        --index-url https://download.pytorch.org/whl/cu128

# ---------------------------------------------------------------------------
# 6. vLLM
# ---------------------------------------------------------------------------
RUN uv pip install --system vllm

# ---------------------------------------------------------------------------
# 7. ML dev tools — HuggingFace ecosystem + MLflow + Unsloth
#    unsloth pulls transformers, peft, trl, datasets, accelerate, huggingface_hub
# ---------------------------------------------------------------------------
RUN uv pip install --system \
        mlflow \
        unsloth

# ---------------------------------------------------------------------------
# 8. Container wiring
# ---------------------------------------------------------------------------
RUN mkdir -p /workspace

WORKDIR /workspace

# code-server HTTP port
EXPOSE 8080

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
