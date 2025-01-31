#!/usr/bin/env bash

echo "========================================"
echo "Installing wireguard"
echo "========================================"

# Install dependencies
apt update
apt install wireguard

# Import key

cat ${key} | tee /etc/wireguard/vm.key
cat ${key} | wg pubkey | tee /etc/wireguard/vm.pub

chmod go= /etc/wireguard/vm.key

# Wireguard configuration

cat << EOF > /etc/wireguard/wg0.conf
[Interface]
Address = 10.10.5.5/32
PostUp = wg set %i private-key /etc/wireguard/%i.key
ListenPort = 51000

[Peer]
PublicKey = ${wgpub}
AllowedIPs = 10.10.5.5/32,10.10.5.1/32
Endpoint = ${endpoint}
EOF

# Starting wireguard

systemctl enable wg-quick@wg0.service
systemctl start wg-quick@wg0.service
systemctl status wg-quick@wg0.service