#!/bin/bash
# Wings setup script for Raspberry Pi 5 (ARM64)
# Prerequisites: Docker must be installed

set -e

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (sudo bash setup.sh)"
    exit 1
fi

# Check Docker
if ! command -v docker &> /dev/null; then
    echo "ERROR: Docker is not installed."
    echo "Install Docker first: curl -sSL https://get.docker.com/ | CHANNEL=stable sh"
    exit 1
else
    echo "==> Docker found, skipping installation."
fi

# Create directories
echo "==> Creating directories..."
mkdir -p /etc/pelican /var/run/wings

# Download Wings
if [ -f /usr/local/bin/wings ]; then
    echo "==> Wings already installed, skipping download."
else
    echo "==> Downloading Wings (ARM64)..."
    curl -L -o /usr/local/bin/wings \
        "https://github.com/pelican-dev/wings/releases/latest/download/wings_linux_arm64"
    chmod u+x /usr/local/bin/wings
    echo "==> Wings downloaded."
fi

# Install systemd service
if [ -f /etc/systemd/system/wings.service ]; then
    echo "==> wings.service already exists, skipping."
else
    echo "==> Installing systemd service..."
    tee /etc/systemd/system/wings.service > /dev/null <<EOF
[Unit]
Description=Wings Daemon
After=docker.service
Requires=docker.service
PartOf=docker.service

[Service]
User=root
WorkingDirectory=/etc/pelican
LimitNOFILE=4096
PIDFile=/var/run/wings/daemon.pid
ExecStart=/usr/local/bin/wings
Restart=on-failure
StartLimitInterval=180
StartLimitBurst=30
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload
    echo "==> systemd service installed."
fi

echo ""
echo "==> Setup complete. Next steps:"
echo "    1. Go to Panel → Admin → Nodes → Create New"
echo "    2. Click the node → Configuration tab → copy the config"
echo "    3. Paste it into /etc/pelican/config.yml"
echo "    4. Test Wings: sudo wings --debug"
echo "    5. If no errors: sudo systemctl enable --now wings"