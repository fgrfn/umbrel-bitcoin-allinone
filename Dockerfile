# 1. UI + Node Umgebung vorbereiten (nur Code, kein Build nötig)
FROM node:20-bullseye AS umbrel-ui
RUN git clone --recursive https://github.com/getumbrel/umbrel-bitcoin.git /umbrel
WORKDIR /umbrel
RUN npm install

# 2. Finales All-in-One Image mit bitcoind + Umbrel UI
FROM debian:bookworm-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl ca-certificates gnupg wget unzip \
    nodejs npm \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install bitcoind (Bitcoin Core)
ENV BITCOIN_VERSION=27.0
WORKDIR /opt
RUN curl -O https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz && \
    tar -xzf bitcoin-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz && \
    cp bitcoin-${BITCOIN_VERSION}/bin/* /usr/local/bin && \
    rm -rf /opt/*

# Copy Umbrel UI from builder stage
COPY --from=umbrel-ui /umbrel /umbrel

# Add start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Working directory for Bitcoin data
WORKDIR /data

EXPOSE 8332 8333 3006
CMD ["/start.sh"]
