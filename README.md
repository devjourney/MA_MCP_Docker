# Music Assistant MCP Docker

A lightweight, containerized deployment setup for the [music-assistant-mcp](https://pypi.org/project/music-assistant-mcp/) server. 

This project provides a robust way to bridge an AI assistant with your local [Music Assistant](https://music-assistant.io/) server via the Model Context Protocol (MCP) using a HTTP transport, without needing to manage Python environments on your host machine.

## Features
- **Lean and Fast**: Built on `python:3.13-slim` and uses the `uv` package manager for rapid installation.
- **Secure Configuration**: Settings and API tokens are injected dynamically at runtime to ensure no secrets are ever baked into the Docker image or checked into version control.

## Getting Started

### 1. Configure the Environment
Copy the example environment file to create your active configuration:
```bash
cp .env.example .env
```
Open the newly created `.env` file and configure your details:
- `MA_SERVER_URL`: The URL of your running Music Assistant server (e.g., `http://192.168.1.100:8095`).
- `MA_TOKEN`: Your API token generated from the Music Assistant UI.

*(Note: The actual `.env` file is git-ignored to keep your token safe.)*

### 2. Build and Run
Use Docker Compose to build the image and start the container as a background daemon:
```bash
docker compose up -d --build
```

### 3. Connect your Client

Because this setup exposes an HTTP Server-Sent Events (SSE) endpoint via the `streamable-http` transport, you'll use an MCP proxy to bridge the connection for standard stdio clients like Claude Code or Claude Desktop.

#### Claude CLI (Claude Code)
To add the containerized server to your Claude CLI configuration, use the following command:

```bash
claude mcp add --transport http music-assistant-docker http://localhost:8668/mcp
```

#### Claude Desktop
As of this writing, Claude Desktop does not directly support connecting via any transport other than stdio. However, there are many libraries and tools you can check out to bridge between stdio and streamable-http transports:

- [mcp-remote](https://www.npmjs.com/package/mcp-remote)
- [mcp-proxy](https://pypi.org/project/mcp-proxy/)
- [mcp-http-stdio-bridge](https://www.npmjs.com/package/@depasquale/mcp-http-stdio-bridge)
- [fastmcp](https://pypi.org/project/fastmcp/) - using create_proxy()

## Customizing the Port
Out of the box, the server operates on port `8668`. If you need to change this due to a local conflict, you must update two places:
1. `MA_MCP_PORT` in your `.env` file.
2. The port mapping (`"8668:8668"`) in `docker-compose.yml`.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
