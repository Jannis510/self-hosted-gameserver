# Homecloud Gaming Server

A self-hosted game server stack running on a **Raspberry Pi 5 (ARM64)**, managed via [Pelican Panel](https://pelican.dev) with Docker-based game server isolation.

> ⚠️ **ARM64 Notice:** This entire stack runs on `linux/arm64`. Wings is currently in **experimental ARM64 status**.

---

## Stack

| Component         | Technology                      | ARM64 Status    |
|-------------------|---------------------------------|-----------------|
| Host OS           | Raspberry Pi OS Bookworm 64-bit | Native          |
| Container Runtime | Docker Engine                   | Official        |
| Panel             | Pelican Panel (Docker Compose)  | Official        |
| Daemon            | Wings                           | ⚠️ Experimental |
| Firewall          | ufw                             | Native          |

---

## Architecture

```
                         ┌─────────────────────────────────────────────┐
  Internet               │              Raspberry Pi 5 (ARM64)         │
     │                   │                                             │
     │  Port 25565 (TCP) │  ┌──────────────────────────────────────┐   │
     ├───────────────────┼─►│  Wings (Docker)                      │   │
     │                   │  │  └─ Minecraft Java :25565            │   │
     │                   │  └──────────────────────────────────────┘   │
     │                   │                          ▲                  │
     │                   │                    Wings API :8080          │
     │                   │  ┌───────────────────────┴──────────────┐   │
     │                   │  │  Pelican Panel — LAN only            │   │
  LAN only               │  └──────────────────────────────────────┘   │
                         └─────────────────────────────────────────────┘
```

**Security model:** Only `:25565` is forwarded publicly via the router. Panel and Wings API are LAN-only.

---

## Status

| Component     | Status     |
|---------------|------------|
| Pelican Panel | 🔲 Planned |
| Wings         | 🔲 Planned |
| Minecraft     | 🔲 Planned |

---

## Setup

Follow the guides in order:

1. [OS Hardening](docs/setup/01-os-hardening.md)
2. [Docker](docs/setup/02-docker.md)
3. [Pelican Panel](docs/setup/03-pelican-panel.md)
4. [Wings](docs/setup/04-wings.md)

---

## Roadmap

See [ROADMAP.md](ROADMAP.md).