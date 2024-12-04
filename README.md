# Pi OpenVpn
Pi OpenVPN is a lightweight Dockerised OpenVPN server designed for Raspberry Pi and other systems. It simplifies the setup processs of an OpenVPN server, allowing secure connections and client management. This project was created to address the lack of maintained OpenVPN Docker solutions for Raspberry Pi, ensuring a reliable and customisable option for users. This project is currently in development, with additional features planned for future releases. 

## Technologies Used 
- **Docker**: To containerise the OpenVPN server.
- **Docker Compose**: For orchestrating container deployment. 
- **EasyRSA**: For managing PKI and certificate generation. 
- **Bash Scripting**: For automating key generation and server initialisation. 

## Project Structure
Below is a description of the files and how they work together: 

### 1. Dockerfile 
- Builds the Docker image for the OpenVPN server. 
- Installs required dependencies such as OpenVPN and EasyRSA. 
- Sets up directories and permissions for certificates and configurations. 
- Copies `gen-keys.sh`, `entrypoint.sh`, and `server.conf` into the container. 

### 2. gen-keys.sh
- A Bash script that: 
    - Initialise the PKI using EasyRSA.
    - Generates the Certificate Authority (CA) and server/client certificates. 
    - Creates HMAC keys for TLS authentication. 
    Copies all necessary keys and certificates to the appropriate directories.

### 3. entrypoint.sh 
- The entry point for the container.
- Executes the `gen-key.sh` script to generate or verify keys/certificates. 
- Copies the sample `server.conf` to the appropriate directory. 
- Starts the OpenVPN server with the provided configuration.
  
### 4. server.conf 
- The sample OpenVPN server configuration file. 
- Key settings include: 
    - `port 1194` and `proto udp4`: OpenVPN listens on UDP port 1194.
    - `dev tun`: Enables tunneling for secure traffic. 
    - `ca`, `cert`, `key`, `dh`: Paths to certificates and keys used for encryption and authentication.
    - `push` options: Pushes network configurations (e.g., DNS and routing) to clients. 
    - `tls-auth`: Protects against DoS attacks. 
    - `data-ciphers`: Specifies supported encryption algorithms for secure communication.

**_Note_**: This is a sample `server.conf`. Future updates will allow users to specify their own server.conf.

### 5. docker-compose.yaml
- Defines the container's configuration and network settings for deployment.
- Maps necessary ports and devices to enable VPN functionality. 
- Uses environment variables for customisation (e.g., VPN name).

## How to Use 
### 1. Clone the Repository 
```bash 
git clone https://github.com/Cyrof/pi-openvpn.git

cd pi-openvpn
```

### 2. Build the Docker Image
Replace `<name>` with your preferred image name: 
```bash 
docker build -t <name> .
```

### 3. Start the OpenVPN Server 
Run the following command to start the OpenVPN server using Docker Compose: 
```bash 
docker-compose -f start-openvpn.ymal up -d
```

### 4. Connect Clients 
- A sample `.ovpn` client configuration file is automatically generated when the server starts. 
- Use this file to connect to the VPN using an OpenVPN client. 

## Planned Features
- Supported for custom `server.conf` files. 
- Push pre-built Docker images to DockerHub for easier deployment. 

## License 
This project is licensed under the Apache 2.0 License. See the [LICENSE](https://github.com/Cyrof/pi-openvpn/blob/main/LICENSE) file for details.

## Contributions 
Contributions are welcome! Feel free to submit a pull request or raise issues for bug fixes, feature requests, or improvements.