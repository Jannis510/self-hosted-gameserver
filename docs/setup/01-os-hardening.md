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

### Step 3 — Allow container ports

Run after Wings is started (see [04 — Wings](04-wings.md)).

**Single Pi — Panel + Wings on the same machine:**

```bash
# SFTP — local network only
sudo ufw route allow proto tcp from <LOCAL_SUBNET> to any port 2022

# Minecraft game servers — public
sudo ufw route allow proto tcp from any to any port 25565
```

> Port 8080 (Wings API) needs no external rule — Panel reaches Wings via `host.docker.internal` on the same host.

**Two Pis — Wings on a separate machine:**

```bash
# Wings API — Panel IP only
sudo ufw route allow proto tcp from <PANEL_IP> to any port 8080

# SFTP — local network only
sudo ufw route allow proto tcp from <LOCAL_SUBNET> to any port 2022

# Minecraft game servers — public
sudo ufw route allow proto tcp from any to any port 25565
```

> Replace `<PANEL_IP>` with the Panel Pi's IP, e.g. `192.168.1.10`.
> Replace `<LOCAL_SUBNET>` with your local subnet, e.g. `192.168.2.0/24`.

---

### Port overview

| Port | Service | Reachable from | Rule type |
|---|---|---|---|
| 22/tcp | SSH | anywhere | `ufw allow` (host) |
| 8080/tcp | Wings API | Panel IP only | `ufw route` — two-Pi setup only |
| 2022/tcp | Wings SFTP | local subnet | `ufw route` |
| 25565/tcp | Minecraft | anywhere | `ufw route` |

> Game server containers are created dynamically by Wings and cannot be allowed by container name — that's why `ufw route` (by port) is used instead of `ufw-docker allow`.