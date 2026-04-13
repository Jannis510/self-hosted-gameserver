# 01 — OS Hardening

<!-- TODO: Document Raspberry Pi OS Bookworm 64-bit hardening (ufw, fail2ban, SSH) once completed. -->

sudo ufw status

sudo ufw allow ssh

sudo ufw allow 25565/tcp

sudo ufw allow from {{LOCAL ADDRESS}} to any port 8080 proto tcp

sudo ufw default deny

sudo ufw enable
