# 06 — Minecraft Vanilla Server

This guide walks through setting up a Vanilla Minecraft Java Edition server using Pelican Panel, and making it reachable from the internet on port `:25565`.

## Prerequisites

- Panel and Wings are running
- Guide [05 — Creating a Server](05-first-server.md) read (general server creation steps apply)

---

## Egg

Use the official Vanilla Minecraft Egg from the Pelican egg repository:

[github.com/pelican-eggs/minecraft](https://github.com/pelican-eggs/minecraft)

Download `egg-vanilla-minecraft.json` and import it in **Admin → Nests → Import Egg**.

---

## Adding a Port Allocation

Before creating the server, make sure port `25565` is available as an allocation on the Wings node.

1. **Admin → Nodes → [your node] → Allocations**
2. Add: IP = the Pi's local IP (e.g. `192.168.1.x`), Port = `25565`

---

## Server Configuration

Create the server as described in [05 — Creating a Server](05-first-server.md) with these specific values:

### Resource Management

| Field | Value |
|-------|-------|
| Memory | 2048–4096 MB depending on player count |
| Disk | 10240 MB (10 GB) |
| CPU | 200% |

### Egg & Environment Variables

| Variable | Value | Notes |
|----------|-------|-------|
| Server Version | e.g. `1.21.4` | Leave blank for latest |
| Server Jar URL | _(leave default)_ | Egg fills this automatically |
| Maximum Players | `20` | Adjust as needed |
| MOTD | Your server name | Shown in the server list |

> The Egg fetches the server jar from Mojang's servers on first install — the Pi needs internet access.

---

## Accepting the EULA

Minecraft requires accepting the EULA before the server will start. On the first boot the server will stop with a message about the EULA.

In the Panel console or via SFTP, edit `eula.txt`:

```
eula=true
```

Then start the server again.

> By setting `eula=true` you agree to Mojang's End User License Agreement: [minecraft.net/eula](https://www.minecraft.net/eula)

---

## Whitelist (Friends-only)

If the server is only meant for specific players, enable the whitelist. Without it, anyone who knows the IP can join.

**Enable in `server.properties`:**

```
white-list=true
```

Restart the server after changing `server.properties`.

**Add players via Panel console:**

```
whitelist add <username>
whitelist remove <username>
whitelist list
```

> Usernames are case-sensitive and tied to the Mojang account. A player cannot join until they are on the whitelist.

---

## Port Forwarding

To make the server reachable from outside your local network, forward port `25565` on your router to the Pi.

1. Open your router's admin interface (usually `192.168.1.1` or `192.168.178.1`)
2. Find the **Port Forwarding** section
3. Add a rule:

| Field | Value |
|-------|-------|
| External Port | `25565` |
| Internal IP | Pi's local IP (e.g. `192.168.1.x`) |
| Internal Port | `25565` |
| Protocol | TCP |

4. Save and apply

> Your Pi needs a **static local IP** for the forwarding rule to stay valid. Set this either via a DHCP reservation in the router or by configuring a static IP on the Pi itself.

---

## Connecting

- **From your local network:** use the Pi's local IP — `192.168.1.x:25565`
- **From the internet:** use your public IP or domain — find your public IP at [whatismyip.com](https://www.whatismyip.com)

> If your public IP changes regularly (no static IP from your ISP), consider a free dynamic DNS service such as [DuckDNS](https://www.duckdns.org) so players can always reach the server via a fixed hostname.