# Basis-Image
FROM node:18-bullseye

# Installiere bitcoind
RUN apt-get update && \
    apt-get install -y wget gnupg && \
    wget https://bitcoin.org/bin/bitcoin-core-26.0/bitcoin-26.0-x86_64-linux-gnu.tar.gz && \
    tar -xzf bitcoin-26.0-x86_64-linux-gnu.tar.gz && \
    cp -r bitcoin-26.0/bin/* /usr/local/bin/ && \
    rm -rf bitcoin-26.0*

# Erstelle App-Verzeichnis
WORKDIR /umbrel

# Kopiere App-Dateien
COPY umbrel/ /umbrel/

# Installiere Abhängigkeiten
RUN npm install

# Kopiere Start-Script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
COPY scripts/start.sh /start.sh
RUN chmod +x /start.sh


# Exponierte Ports
EXPOSE 3005
EXPOSE 8333
EXPOSE 8332

# Volumes
VOLUME ["/data", "/bitcoin"]

# Setze EntryPoint
ENTRYPOINT ["/entrypoint.sh"]
ENTRYPOINT ["/start.sh"]
