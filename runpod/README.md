# RunPod Dev Template — code-server + Python + uv + PyTorch + vLLM

A self-contained RunPod template that gives you VS Code in the browser with a full ML/Python dev stack pre-installed.

**What's inside**
- code-server (VS Code)
- Extensions: Python, Pylance, Ruff, Jupyter, GitLens
- uv (fast Python package manager)
- PyTorch + CUDA 13
- vLLM

---

## 1. Build the Docker image

```bash
cd runpod/

docker buildx build --platform linux/amd64 -t aravindh12/codeserver-runpod .
```

> **CUDA version note**: The Dockerfile defaults to `nvidia/cuda:13.0.0`. If that tag is not yet on Docker Hub, override it:
> ```bash
> docker build --build-arg CUDA_VERSION=12.6.3 -t <your-dockerhub-user>/runpod-codeserver:latest .
> ```

> **Build time warning**: PyTorch + vLLM installs are large. Expect 20–40 min and a final image of ~25–50 GB.

---

## 2. Push to Docker Hub (or GHCR)

```bash
docker push <your-dockerhub-user>/runpod-codeserver:latest
```

---

## 3. Create the RunPod Template

1. Go to **RunPod → Templates → New Template**
2. Fill in the fields:

| Field | Value |
|---|---|
| Template Name | `codeserver-dev` |
| Container Image | `<your-dockerhub-user>/runpod-codeserver:latest` |
| Container Disk | `50 GB` (minimum; increase for large models) |
| Volume Mount Path | `/workspace` |

3. **Expose HTTP port**  
   Under **Expose HTTP Ports**, add port `8080`.

4. **Environment Variables**  
   Add the following variable:

   | Key | Value |
   |---|---|
   | `PASSWORD` | *(your chosen password)* |

5. Click **Save Template**.

---

## 4. Launch a Pod

1. Go to **RunPod → Deploy → GPU Cloud** (or Secure Cloud).
2. Select a GPU with CUDA 13 support (e.g. H100, A100, RTX 4090).
3. Pick your saved template.
4. Click **Deploy On-Demand**.

---

## 5. Connect to code-server

1. Once the pod is **Running**, click **Connect**.
2. Open the **HTTP 8080** link — this opens code-server in your browser.
3. Enter the password you set in the `PASSWORD` env var.

---

## 6. Working with uv inside code-server

Open the integrated terminal in code-server and use `uv` normally:

```bash
# create a new project venv
uv venv .venv
source .venv/bin/activate

# install packages
uv pip install <package>

# run a script
uv run python main.py
```

---

## Notes

- Persistent storage lives at `/workspace` (backed by RunPod network volume if configured).
- PyTorch and vLLM are installed system-wide so they are available even without a venv.
- To update vLLM or PyTorch without rebuilding the image, use `uv pip install --system --upgrade vllm` in the terminal.
