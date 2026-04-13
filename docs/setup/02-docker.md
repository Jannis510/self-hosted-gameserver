# 02 — Docker on ARM64

## Why Docker?

Both the Pelican Panel and Wings are run as Docker containers in this setup.

**Panel** is only available as a Docker image — there is no native install option.

**Wings** can run natively as a binary, but Docker is preferred:
- Easier to update (pull new image, recreate container)
- No manual binary management or systemd unit maintenance
- Consistent environment regardless of host OS state

Docker Compose is used to manage both services. Each has its own `compose.yml` with environment variables sourced from a `.env` file.

---

## Installation

Install Docker Engine using the official convenience script. This works on Raspberry Pi OS Bookworm 64-bit (ARM64).

```bash
curl -fsSL https://get.docker.com | sudo sh
```

Verify the installation:

```bash
docker --version
docker compose version
```

---

## Running Docker Without sudo

By default, Docker requires `sudo`. Add your user to the `docker` group so you can run Docker commands directly:

```bash
sudo usermod -aG docker $USER
```

Apply the group change without logging out:

```bash
newgrp docker
```

Verify it works:

```bash
docker ps
```

> Re-login or reboot if `newgrp docker` is not enough — SSH sessions in particular sometimes require a full re-login for group changes to take effect.

> **Security note:** Members of the `docker` group have effective root access on the host. Only add trusted users.

---

## Enabling Docker on Boot

Docker is enabled at startup automatically by the install script. To verify:

```bash
sudo systemctl is-enabled docker
```

Should output `enabled`. If not:

```bash
sudo systemctl enable docker
```

---

## Docker & UFW

Docker bypasses UFW by default. This is fixed via `ufw-docker` — installation and all port rules are managed centrally in [01 — OS Hardening](01-os-hardening.md).