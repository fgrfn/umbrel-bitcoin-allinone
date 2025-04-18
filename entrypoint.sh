#!/bin/bash

# Check ob bitcoin-config.json vorhanden ist
CONFIG_PATH="/data/bitcoin-config.json"

if [ -f "$CONFIG_PATH" ]; then
  echo "✔️ bitcoin-config.json gefunden: $CONFIG_PATH"
else
  echo "⚠️ bitcoin-config.json nicht gefunden, lege Dummy an..."
  echo '{}' > "$CONFIG_PATH"
fi

# Starte node & bitcoind wie gewohnt
exec npm start
