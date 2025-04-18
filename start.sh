#!/bin/bash

echo "⛓️  Starting bitcoind..."
bitcoind -datadir=/data -printtoconsole -rpcuser=umbrel -rpcpassword=umbrel &

echo "🌐 Starting Umbrel Bitcoin UI..."
cd /umbrel && npm start
