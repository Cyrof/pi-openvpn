#! /bin/bash

EASYRSA=/etc/easy-rsa
VPN_NAME=${VPN_NAME:-"pivpn"}

# navigate into easy rsa dir 
cd "$EASYRSA"

# initialise easy-rsa pki
if [ ! -d "$EASYRSA/pki" ]; then 
    echo "Initialising PKI..."
    ./easyrsa init-pki
fi

# generate certificate authority 
if [ ! -f "$EASYRSA/pki/ca.crt" ]; then 
    echo "Generating certificate authority..."
    # ./easyrsa build-ca nopass
    echo -e "\n$VPN_NAME\n" | ./easyrsa build-ca nopass 
fi

# generate diffie-hellman 
if [ ! -f "$EASYRSA/pki/dh.pem" ]; then
    echo "Generating Diffie-Hellman parameters..."
    ./easyrsa gen-dh
fi 

# Generate server certificates
if [ ! -f "$EASYRSA/pki/issued/server.crt" ]; then
    echo "Generating server certificate..."
    echo -e "yes\n" | ./easyrsa build-server-full server nopass
fi 

# generate HMAC key 
if [ ! -f "$EASYRSA/pki/ta.key" ]; then
    echo "Generating HMAC signature..."
    openvpn --genkey secret "$EASYRSA/pki/ta.key"
fi

# generate openvpn recovation certificate 
if [ ! -f "$EASYRSA/pki/crl.pem" ]; then
    echo "Generating recovation certificate..."
    ./easyrsa gen-crl
fi 

# copy server certificates and keys 
echo "Copying certificates and keys..." 
cp -rp "$EASYRSA/pki/"{ca.crt,dh.pem,ta.key,crl.pem,issued,private} /etc/openvpn/server/

# Generate client cert and keys 
echo "Generating client certificates and keys"
# ./easyrsa build-client-full clientname nopass # should add confirmation 
echo -e "yes\n" | ./easyrsa build-client-full clientname nopass 

# Create directory & copy files to it 
echo "Copying client certificates and keys..."
mkdir -p /etc/openvpn/client/clientname
cp -rp "$EASYRSA/pki/"{ca.crt,issued/clientname.crt,private/clientname.key} /etc/openvpn/client/clientname/
