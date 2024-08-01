
# Linux System Administration and Website Deployment

## Project Overview
This project covers various aspects of Linux system administration, including file management, user/group handling, service control, process management, and website deployment. It provides practical experience with Linux commands and configurations.

---

## 1. Creating and Editing Text Files

### Using Nano
```bash
nano server_config.txt
# Add the following content:
# Server Name: WebServer01
# IP Address: 192.168.59.19
# OS: Ubuntu 20.04
# Save with: Ctrl+O, Enter, Ctrl+X


2. User & Group Management
Adding a User

bash

sudo adduser developer

Removing a User

bash

sudo deluser developer

Managing Groups
Create a Group

bash

sudo groupadd devteam

Add User to Group

bash

sudo usermod -aG devteam developer

Remove User from Group

bash

sudo gpasswd -d developer devteam

3. File Permissions Management
View File Permissions

bash

ls -l server_config.txt

Change Permissions

bash

chmod 644 server_config.txt

Change Ownership

bash

sudo chown developer:devteam server_config.txt

Verify Changes

bash

ls -l server_config.txt

4. Controlling Services and Daemons
Start Apache Service

bash

sudo systemctl start apache2

Enable Apache Service on Boot

bash

sudo systemctl enable apache2

Stop Apache Service

bash

sudo systemctl stop apache2

Disable Apache Service

bash

sudo systemctl disable apache2

Check Apache Service Status

bash

sudo systemctl status apache2

Understanding Daemons

    The sshd daemon provides SSH access to the server.

5. Process Handling
List All Running Processes

bash

ps aux

View Processes in Real-Time

bash

top

Kill a Process

bash

kill <PID>

Run a Process with Lower Priority

bash

nice -n 10 sleep 100 &

Change Process Priority

bash

renice +10 <PID>

6. Creating and Deploying a Static Website with Apache2
Update Package Lists

bash

sudo apt update

Install Apache2

bash

sudo apt install apache2

Start Apache2 Service

bash

sudo systemctl start apache2

Enable Apache2 to Start on Boot

bash

sudo systemctl enable apache2

Verify Installation

    Open a web browser and navigate to http://your_server_ip

Create Website Directory

bash

cd /var/www/html
sudo mkdir mystaticwebsite
sudo chown -R $USER:$USER /var/www/html/mystaticwebsite

Create HTML File

bash

nano /var/www/html/mystaticwebsite/index.html
# Add the following content:
# <!DOCTYPE html>
# <html>
# <head>
#   <title>My Static Website</title>
#   <link rel="stylesheet" type="text/css" href="styles.css">
# </head>
# <body>
#   <h1>Welcome to My Static Website</h1>
#   <p>This is a simple static website using Apache2.</p>
#   <script src="script.js"></script>
# </body>
# </html>
# Save with: Ctrl+O, Enter, Ctrl+X

Create CSS File

bash

nano /var/www/html/mystaticwebsite/styles.css
# Add the following content:
# body {
#   font-family: Arial, sans-serif;
#   background-color: #f0f0f0;
#   text-align: center;
#   margin: 0;
#   padding: 20px;
# }
# h1 {
#   color: #333;
# }
# Save with: Ctrl+O, Enter, Ctrl+X

Create JavaScript File

bash

nano /var/www/html/mystaticwebsite/script.js



