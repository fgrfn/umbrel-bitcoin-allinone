#!/bin/bash

echo "⛓️  Starting bitcoind..."
bitcoind -datadir=/bitcoin -printtoconsole -server=1 -rpcbind=0.0.0.0 -rpcallowip=127.0.0.1 &

echo "🌐 Starting Umbrel Bitcoin UI..."
cd /umbrel && npm start
