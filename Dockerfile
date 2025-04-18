FROM node:20-bullseye AS umbrel-ui

# 1. Baue Umbrel UI
RUN git clone --recursive https://github.com/getumbrel/umbrel-bitcoin.git /umbrel
WORKDIR /umbrel
RUN npm install && npm run build

# 2. Finaler Container mit Bitcoind + Umbrel
FROM debian:bookworm-slim

# Install dependencies
RUN apt-get update && apt-get install -y curl ca-certificates wget unzip gnupg

# 3. Installiere Bitcoind
ENV BITCOIN_VERSION=27.0
WORKDIR /opt
RUN curl -O https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz && \
    tar -xzf bitcoin-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz && \
    cp bitcoin-${BITCOIN_VERSION}/bin/* /usr/local/bin && \
    rm -rf /opt/*

# 4. Umbrel UI kopieren
COPY --from=umbrel-ui /umbrel /umbrel

# 5. Konfiguration + Startscript
COPY start.sh /start.sh
RUN chmod +x /start.sh
WORKDIR /data

EXPOSE 3006 8332 8333
CMD ["/start.sh"]
