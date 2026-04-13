# 05 — Creating a Server in Pelican

This guide covers how to create and start any game server through the Pelican Panel. The steps are the same regardless of game — only the Egg and environment variables differ.

## Prerequisites

- Panel is running and reachable
- Wings is connected (node shows green in Admin → Nodes)
- At least one Egg is imported (see below)

---

## Importing an Egg

Eggs are server templates that define how a game server is installed and started. Pelican does not ship with Eggs built in — you import them manually.

The official Egg repository is at [github.com/pelican-eggs](https://github.com/pelican-eggs).

1. Download the Egg JSON file from the repository (e.g. `egg-vanilla-minecraft.json`)
2. In the Panel: **Admin → Nests → Import Egg**
3. Select the downloaded JSON file and import

---

## Creating a Server

Go to **Admin → Servers → Create New**.

### Details

| Field | What to enter |
|-------|---------------|
| Server Name | A readable name, e.g. `minecraft-vanilla` |
| Server Owner | Your admin user |

### Allocation

| Field | What to enter |
|-------|---------------|
| Node | Select your Wings node |
| Default Allocation | Select the port you want the server to use (e.g. `25565`) |

> Allocations (port mappings) are managed per node under **Admin → Nodes → [your node] → Allocations**. Add a port there first if none are available.

### Application Feature Limits

| Field | Recommended |
|-------|-------------|
| Databases | 0 (unless the game needs one) |
| Backups | 1–3 |
| Allocations | 1 |

### Resource Management

Set limits appropriate for the game and your Pi's available RAM.

| Field | Example (Minecraft) |
|-------|---------------------|
| CPU Limit | 200% (= 2 cores) |
| Memory | 2048 MB |
| Disk | 10240 MB |

> The Pi 5 has 8 GB RAM. Leave headroom for Wings, the Panel, and the OS (~1.5 GB).

### Nest & Egg

| Field | What to enter |
|-------|---------------|
| Nest | The nest the Egg belongs to (e.g. `Minecraft`) |
| Egg | The specific Egg (e.g. `Vanilla Minecraft`) |

After selecting the Egg, the **Environment Variables** section will populate with the options defined by that Egg.

---

## Starting the Server

1. Go to the server in the Panel (not Admin view, use the main dashboard)
2. Click **Start**
3. Watch the console — the server will install on first start before booting

If the server does not start, check:
- Wings node is online (green in Admin → Nodes)
- Enough RAM and disk available on the node
- Console output for error messages