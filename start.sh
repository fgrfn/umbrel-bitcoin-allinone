#!/bin/bash

# Fallback-Werte setzen, falls ENV nicht gesetzt ist
: "${RPC_USER:=umbrel}"
: "${RPC_PASSWORD:=umbrel}"

echo "⚙️  Generating bitcoin.conf from ENV..."
mkdir -p /bitcoin/.bitcoin

cat > /bitcoin/.bitcoin/bitcoin.conf <<EOF
server=1
rpcbind=0.0.0.0
rpcallowip=127.0.0.1
rpcuser=${RPC_USER}
rpcpassword=${RPC_PASSWORD}
EOF

echo "✅ bitcoin.conf written:"
cat /bitcoin/.bitcoin/bitcoin.conf

echo "⛓️  Starting bitcoind..."
bitcoind -datadir=/bitcoin -printtoconsole &

echo "🌐 Starting Umbrel Bitcoin UI..."
cd /umbrel
npm start
