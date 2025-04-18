# 1. Baue Umbrel-Bitcoin (Node App)
FROM node:20-bullseye AS umbrel-ui

# Hole den Quellcode
RUN git clone --recursive https://github.com/getumbrel/umbrel-bitcoin.git /umbrel
WORKDIR /umbrel
RUN npm install

# 2. Finales Image
FROM debian:bookworm-slim

# Version definieren
ENV BITCOIN_VERSION=27.0

# System-Tools & Dependencies installieren
RUN apt-get update && apt-get install -y \
    curl gnupg ca-certificates wget unzip \
    nodejs npm \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Arbeitsverzeichnis für Bitcoin-Daten
WORKDIR /bitcoin

# Bitcoind installieren
RUN curl -O https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz && \
    tar -xzf bitcoin-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz && \
    cp bitcoin-${BITCOIN_VERSION}/bin/* /usr/local/bin && \
    rm -rf /bitcoin/*

# Umbrel Bitcoin UI kopieren
COPY --from=umbrel-ui /umbrel /umbrel

# Start-Skript einfügen
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Mountpoint für Daten (Unraid Volume)
VOLUME /bitcoin

# Ports freigeben
EXPOSE 8332 8333 3006

# Start-Kommando
CMD ["/start.sh"]
