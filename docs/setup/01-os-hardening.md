# 01 — OS Hardening

## Firewall (UFW)

```bash
sudo ufw status
```

```bash
sudo ufw allow ssh
sudo ufw allow 25565/tcp
sudo ufw allow from <LOCAL_ADDRESS> to any port 8080 proto tcp
sudo ufw default deny incoming
sudo ufw enable
```

### Why these rules?

| Rule | Port | Reachable from | Reason |
|---|---|---|---|
| `allow ssh` | 22/tcp | anywhere | Remote access to the Pi |
| `allow 25565/tcp` | 25565/tcp | anywhere | Minecraft server, needs to be publicly reachable |
| `allow from <LOCAL_ADDRESS> … 8080` | 8080/tcp | LAN only | Wings API — only called internally by the Panel, never from the internet |
| `default deny incoming` | — | — | Blocks everything not explicitly allowed |

> Replace `<LOCAL_ADDRESS>` with the LAN IP or subnet of the Panel, e.g. `192.168.1.0/24`.