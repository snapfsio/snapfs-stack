# SnapFS Stack

`snapfs-stack` provides a Docker Compose stack for running the core SnapFS
services locally:

- **NATS + JetStream** – event backbone
- **Redis** – L1 hash cache
- **MySQL** – authoritative metadata store
- **snapfs-gateway** – HTTP/JSON + WebSocket API
- **snapfs-agent-mysql** – consumes file events and writes to MySQL

All images are pulled from `ghcr.io/snapfsio/`

## Requirements

- Docker
- Docker Compose (`docker compose` CLI)

## Quick start

```bash
curl -fsSL https://raw.githubusercontent.com/snapfsio/snapfs-stack/master/install.sh | sh
```

## Usage

From the repo root:

```bash
make up
```

or

```bash
docker compose up -d
```

## License

Apache 2.0
