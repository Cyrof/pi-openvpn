#! /bin/bash

# generate key and certificates if not exist 
echo "Setting up openvpn server and client..."
/usr/local/bin/gen-keys.sh

# configure openvpn configuration 
echo "Copying default config file..."
cp "$DEFAULT_LOC/server.conf" /etc/openvpn/server/

# verify permission 
DIR=/etc/openvpn/server/

chmod 600 "$DIR"/ca.crt
chmod 600 "$DIR"/issued/server.crt
chmod 600 "$DIR"/private/server.key
chmod 600 "$DIR"/dh.pem
chmod 600 "$DIR"/ta.key
chown -R root:root "$DIR"


# start OpenVPN server 
echo "Starting OpenVPN server..."
exec "$@"
