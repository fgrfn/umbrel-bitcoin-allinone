#!/bin/bash

# Set default values if not provided
RPCUSER=${RPCUSER:-umbrel}
RPCPASSWORD=${RPCPASSWORD:-umbrel}

# bitcoin.conf schreiben
mkdir -p /bitcoin/.bitcoin
cat <<EOF > /bitcoin/.bitcoin/bitcoin.conf
server=1
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
rpcallowip=0.0.0.0
txindex=1
EOF

# Umbrel Config mit gleichen Werten erzeugen
cat <<EOF > /bitcoin/.bitcoin/umbrel-bitcoin.conf
server=1
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
rpcallowip=0.0.0.0
txindex=1
EOF

echo "✅ Konfiguration geschrieben: bitcoin.conf & umbrel-bitcoin.conf"

# Start Bitcoin
echo "⛓️  Starting bitcoind..."
bitcoind -datadir=/bitcoin/.bitcoin &

# Start Umbrel UI
echo "🌐 Starting Umbrel Bitcoin UI..."
cd /umbrel && npm start
