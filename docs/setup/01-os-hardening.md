# 01 — OS Hardening

## Firewall (UFW)

### Single Pi — Panel + Wings on the same machine

```bash
sudo ufw allow ssh
sudo ufw allow 25565/tcp
sudo ufw allow from <LOCAL_SUBNET> to any port 2022 proto tcp
sudo ufw default deny incoming
sudo ufw enable
```

> Port 8080 (Wings API) needs no rule here — Panel and Wings communicate over localhost.

---

### Two Pis — Panel and Wings on separate machines

**Panel Pi:**

```bash
sudo ufw allow ssh
sudo ufw allow from <LOCAL_SUBNET> to any port 2022 proto tcp
sudo ufw default deny incoming
sudo ufw enable
```

**Wings Pi:**

```bash
sudo ufw allow ssh
sudo ufw allow 25565/tcp
sudo ufw allow from <PANEL_IP> to any port 8080 proto tcp
sudo ufw allow from <LOCAL_SUBNET> to any port 2022 proto tcp
sudo ufw default deny incoming
sudo ufw enable
```

---

### Why these rules?

| Rule | Port | Reachable from | Reason |
|---|---|---|---|
| `allow ssh` | 22/tcp | anywhere | Remote access to the Pi |
| `allow 25565/tcp` | 25565/tcp | anywhere | Minecraft server, needs to be publicly reachable — Wings Pi only |
| `allow from <PANEL_IP> … 8080` | 8080/tcp | Panel IP only | Wings API — only needed when Panel and Wings run on separate machines |
| `allow from <LOCAL_SUBNET> … 2022` | 2022/tcp | LAN only | Restricted to local subnet |
| `default deny incoming` | — | — | Blocks everything not explicitly allowed |

> Replace `<PANEL_IP>` with the IP of the Panel Pi, e.g. `192.168.1.10`.
> Replace `<LOCAL_SUBNET>` with your local subnet, e.g. `192.168.2.0/24`.