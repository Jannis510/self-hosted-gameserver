# 03 — Pelican Panel + Caddy

## Prerequisites

- Docker and Docker Compose installed
- Port 80 and 443 available on the host

## Configuration

Copy the example environment file and fill in your values:

```bash
cp .env.example .env
```

Edit `.env`:

```env
PANEL_VERSION=v1.0.0-beta33   # check latest at github.com/pelican-dev/panel/releases
APP_URL=http://192.168.x.x    # your local IP or domain (https://panel.yourdomain.com)
ADMIN_EMAIL=your@email.com    # used for Let's Encrypt if APP_URL starts with https://
```

## Starting the Panel

```bash
cd panel/
docker compose up -d
```

## Installation

Open the installer in your browser at `APP_URL/installer` and follow the steps.

### Recommended settings

| Setting | Value | Reason |
|---|---|---|
| Database | SQLite | Simple setup, easy to backup |
| Cache | Filesystem | No Redis needed |
| Session | Filesystem | No Redis needed |
| Queue | Database | No Redis needed |

## Saving the App Key

After the first start, an `APP_KEY` is automatically generated. Save it somewhere safe — without it, all encrypted data is unrecoverable even if you have a database backup.

```bash
docker compose exec panel cat /var/www/html/.env
```

> ⚠️ Never commit the App Key or the `.env` file to the repository.

## Stopping the Panel

```bash
docker compose down
```

## HTTP vs HTTPS

### HTTP (local / testing)

No additional configuration needed. Set `APP_URL` to your local IP:

```env
APP_URL=http://192.168.x.x
```

Panel is only reachable inside your local network.

### HTTPS (production)

Requires a domain name — Let's Encrypt does not issue certificates for IP addresses.

1. Point your domain to your public IP via DNS: `panel.yourdomain.com` → your public IP
2. Forward ports 80 and 443 on your router to the Pi
3. Update `.env`:

```env
APP_URL=https://panel.yourdomain.com
ADMIN_EMAIL=your@email.com
```

4. Restart the panel:

```bash
docker compose down
docker compose up -d
```

Caddy will automatically obtain a Let's Encrypt certificate on first start.

> ⚠️ Exposing the panel publicly means it is reachable from the internet.
> Consider setting up WireGuard VPN instead so the panel stays internal and is only accessible over VPN.