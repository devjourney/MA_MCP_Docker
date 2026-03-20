FROM python:3.13-slim

# uv for fast, reproducible installs — no venv overhead needed inside a container
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

# Install from PyPI — dependencies are resolved by the package itself; no need to pin separately
RUN uv pip install --system music-assistant-mcp

EXPOSE 8668

CMD ["music-assistant-mcp"]
