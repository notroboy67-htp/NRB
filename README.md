🟢 NRB Panel

A modern VPS and server management panel.

NRB Panel is designed to provide a clean interface for managing servers, accessing files remotely, and monitoring server status.

✨ Features

- 🎨 Modern Dashboard — Clean, responsive interface.
- 🖥️ VPS Management — Organize and manage server instances.
- 📁 Tailscale File Manager — Connect to a VM using its Tailscale IP and SSH/SFTP to manage its files.
- 🐳 Docker Support — Install Docker on supported Ubuntu/Debian systems.
- 🔐 Secure Access — Authentication and access controls.
- 📂 File Operations — Browse, upload, download, create, edit, and delete files, subject to permissions.
- 📱 Mobile-Friendly Design — Access the panel from a phone or computer.
- ⚙️ Simple Installation — Shell scripts for installation and startup.

«Note: Features depend on the configured backend. Docker installation alone does not enable container provisioning, and Tailscale file access requires network connectivity and working SSH authentication.»

💻 Requirements

- Ubuntu or Debian Linux
- Root or "sudo" access for installation
- Python 3
- Internet connectivity for installation
- Tailscale connectivity to target VMs for remote file management
- SSH enabled on target VMs
- Docker, if using the Docker backend

🚀 Installation

1. Clone the repository

Replace "YOUR_GITHUB_USERNAME" with your GitHub username.

git clone https://github.com/YOUR_GITHUB_USERNAME/NRB.git
cd NRB

2. Install NRB Panel

sudo bash install.sh

3. Start the panel

./start.sh

Open the panel in your browser using your server's IP address and configured port.

For example, if the panel uses port "5000":

http://YOUR_SERVER_IP:5000

Security: Configure HTTPS and appropriate firewall rules before exposing the panel publicly. Do not expose an administrative panel over untrusted networks without suitable protection.

📁 Tailscale File Manager

The File Manager is intended to connect to remote VMs through Tailscale.

Connection details

1. Install and configure Tailscale on the panel server and target VM.
2. Ensure the target VM is reachable through the Tailscale network.
3. Enable SSH on the target VM.
4. Open the File Manager.
5. Enter the target VM's Tailscale IP address.
6. Enter the SSH port and username.
7. Authenticate using an SSH key or another supported secure method.
8. Click Connect.

Once connected, the File Manager can display the remote VM's files and directories, provided the backend supports the requested operations and the SSH account has the necessary permissions.

Never commit SSH private keys, passwords, API tokens, or other secrets to GitHub.

🐳 Docker Support

Docker can be installed on supported Ubuntu/Debian systems using the included installer, if present in the repository:

sudo bash install-docker.sh

Verify the installation:

docker --version
docker info

Docker must be integrated with the panel's backend before the panel can provision and manage containers.

⚙️ Configuration

Configure environment variables using the project's supported configuration method.

Typical settings may include:

- Panel port
- Database location
- Session secret
- Administrator setup
- SSH connection settings

Do not use example secrets in production. Generate strong, unique secrets and store them outside source control.

🛠️ Troubleshooting

Panel does not start

Check the Python version and dependencies:

python3 --version
python3 -m pip check

Review the startup error and confirm that the configured port is available.

Tailscale connection fails

Check Tailscale connectivity:

tailscale status
tailscale ping 100.x.x.x

Replace "100.x.x.x" with the target VM's actual Tailscale IP.

Test SSH separately:

ssh USERNAME@100.x.x.x

Replace "USERNAME" with the actual SSH username.

If SSH fails, verify network access, SSH service status, authentication, firewall rules, and Tailscale access policies.

Docker is unavailable

sudo systemctl status docker
docker info

Confirm that Docker is installed and running and that the panel backend has the necessary permissions.

🔒 Security

- Use HTTPS for public deployments.
- Use strong administrator credentials.
- Restrict access to trusted users.
- Verify SSH host keys.
- Prefer SSH keys over password-based authentication where practical.
- Never expose SSH private keys in the browser or GitHub repository.
- Protect session secrets and environment files.
- Apply appropriate file permissions and authorization checks.
- Back up your database and important server data.

📂 Repository Structure

The exact structure depends on the files included in your release. A typical project may contain:

NRB/
├── nrb.py
├── requirements.txt
├── install.sh
├── install-docker.sh
├── start.sh
├── backend_check.py
├── templates/
├── static/
├── services/
├── backends/
├── tests/
├── vps_data/
├── backups/
└── README.md

🧪 Testing

Before production use, test:

- Login and access control
- VPS creation and lifecycle operations
- Docker provisioning, if implemented
- Tailscale connectivity
- SSH/SFTP authentication
- File upload, download, edit, rename, and deletion
- Path traversal protection
- Mobile responsiveness
- Database persistence and backups

Only advertise a feature as working after it has been implemented and tested.

📜 License

Choose a license before publishing this repository. If you want others to use, modify, and redistribute NRB Panel, consider an appropriate open-source license.

---

NRB Panel — Simple server management, with remote access through Tailscale.
