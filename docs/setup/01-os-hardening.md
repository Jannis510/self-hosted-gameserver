# 01 — OS Hardening

## Kernel — cgroup Memory

Docker needs cgroup memory accounting enabled so the Panel dashboard can display RAM usage per container. On Raspberry Pi OS this is not active by default.

Edit `/boot/firmware/cmdline.txt`:

```bash
sudo nano /boot/firmware/cmdline.txt
```

Append to the **end of the existing line** (do not add a new line):

```
cgroup_enable=memory cgroup_memory=1 swapaccount=1
```

Example — the line should look something like this afterwards:

```
console=serial0,115200 console=tty1 root=PARTUUID=... rootfstype=ext4 fsck.repair=yes rootwait cgroup_enable=memory cgroup_memory=1 swapaccount=1
```

Then reboot:

```bash
sudo reboot
```

> Without this, memory bars in the Panel dashboard will be empty or missing.

---

## Firewall (UFW + ufw-docker)

This is the single place for all firewall configuration — host rules and Docker container ports alike.

> **Why ufw-docker?** Docker bypasses UFW by writing its own iptables rules directly. A plain `ufw allow 25565` has no effect on Docker-exposed ports. `ufw-docker` fixes this by hooking into the `DOCKER-USER` chain, which Docker reserves exactly for custom rules.

---

### Step 1 — Base UFW setup

Run on every Pi before Docker is installed:

```bash
sudo ufw allow ssh
sudo ufw default deny incoming
sudo ufw enable
```

> SSH uses port 22. Wings SFTP (port 2022) is a container port and is configured later in Step 3 via `ufw route`.

---

### Step 2 — Install ufw-docker

Run after Docker is installed (see [02 — Docker](02-docker.md)):

```bash
sudo wget -O /usr/local/bin/ufw-docker \
  https://github.com/chaifeng/ufw-docker/raw/master/ufw-docker
sudo chmod +x /usr/local/bin/ufw-docker
sudo ufw-docker install
sudo systemctl restart ufw
```

`ufw-docker install` patches `/etc/ufw/after.rules` only — no changes to Docker itself. After this, all container ports are blocked by default.

---

#### Narrow down LAN access (recommended)

By default, ufw-docker adds RETURN rules that let all private-subnet traffic (10.x, 192.168.x) bypass the block and reach all container ports. Comment these out to enforce your `ufw route` rules for LAN traffic as well:

```bash
sudo nano /etc/ufw/after.rules
```

Find and comment out these two lines:

```
# -A DOCKER-USER -j RETURN -s 10.0.0.0/8
# -A DOCKER-USER -j RETURN -s 192.168.0.0/16
```

> Without this change, any device on your local network can reach all Docker container ports regardless of your `ufw route` rules below.

Restart UFW after saving:

```bash
sudo systemctl restart ufw
```

---

### Step 3 — Allow container ports

Run after Wings is started (see [04 — Wings](04-wings.md)).

**Single Pi — Panel + Wings on the same machine:**

```bash
# Panel — LAN only
sudo ufw route allow proto tcp from <LOCAL_SUBNET> to any port 80

# Wings API — LAN only
sudo ufw route allow proto tcp from <LOCAL_SUBNET> to any port 8080

# Wings SFTP — LAN only
sudo ufw route allow proto tcp from <LOCAL_SUBNET> to any port 2022

# Minecraft game servers — public
sudo ufw route allow proto tcp from any to any port <MINECRAFT_PORT>
```

**Two Pis — Wings on a separate machine:**

```bash
# Wings API — Panel IP only
sudo ufw route allow proto tcp from <PANEL_IP> to any port 8080

# Wings SFTP — LAN only
sudo ufw route allow proto tcp from <LOCAL_SUBNET> to any port 2022

# Minecraft game servers — public
sudo ufw route allow proto tcp from any to any port <MINECRAFT_PORT>
```

> Replace `<LOCAL_SUBNET>` with your local subnet, e.g. `192.168.2.0/24`.
> Replace `<PANEL_IP>` with the Panel Pi's IP, e.g. `192.168.1.10` (two-Pi only).
> Replace `<MINECRAFT_PORT>` with the port(s) your game server uses, e.g. `25565`. Add one rule per port.

Reload UFW after adding all rules:

```bash
sudo ufw reload
```

---

### Port overview

| Port | Service | Reachable from | Rule type |
|---|---|---|---|
| 22/tcp | SSH | anywhere | `ufw allow` (host) |
| 8080/tcp | Wings API | Panel IP only | `ufw route` — two-Pi setup only |
| 2022/tcp | Wings SFTP | local subnet | `ufw route` |
| 25565/tcp | Minecraft | anywhere | `ufw route` |

> Game server containers are created dynamically by Wings and cannot be allowed by container name — that's why `ufw route` (by port) is used instead of `ufw-docker allow`.