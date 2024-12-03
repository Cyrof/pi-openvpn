# base image 
FROM debian:stable-slim

ENV DEFAULT_LOC=/usr/local/bin

RUN apt-get update && apt-get install -y \
    openvpn \
    easy-rsa && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy easy rsa config to another location
RUN cp -r /usr/share/easy-rsa /etc/

# Create required directories and set permissions 
RUN mkdir -p /usr/local/bin

# copy initialiastion and entrypoint scripts 
COPY gen-keys.sh /usr/local/bin/
COPY entrypoint.sh /usr/local/bin/
COPY server.conf /usr/local/bin/

# make script executable 
RUN chmod +x /usr/local/bin/gen-keys.sh /usr/local/bin/entrypoint.sh

# Expose the OpenVPN port (default is UDP/1194)
EXPOSE 1194/udp

# set entry point to the script 
ENTRYPOINT ["entrypoint.sh"]
CMD ["openvpn", "--config", "/usr/local/bin/server.conf"]
# CMD ["systemctl", "enable", "--now", "openvpn-server@server"]