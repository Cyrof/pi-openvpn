#! /bin/bash 

EASYRSA=/etc/easy-rsa
PUBLIC_IP=$(curl -s ifconfig.me) # get public IP address

# Generate client.ovpn
echo "Generating client ovpn..."
cat > "/etc/openvpn/client/clientname/client.ovpn" <<EOF
client 
dev tun 
proto udp 
remote $PUBLIC_IP 1194
resolv-retry infinite 
nobind
persist-key
persist-tun 
remote-cert-tls server 
tls-auth ta.key 1
cipher AES-256-CBC
auth SHA512
data-ciphers AES-256-GCM:AES-128-GCM:CHACHA20-POLY1305:AES-256-CBC
verb 3

<ca>
$(cat "/etc/openvpn/server/ca.crt")
</ca>
<cert>
$(cat "/etc/openvpn/client/clientname/clientname.crt")
</cert>
<key>
$(cat "/etc/openvpn/client/clientname/clientname.key")
</key>
<tls-auth>
$(cat "/etc/openvpn/server/ta.key")
</tls-auth>
EOF
