#!/bin/bash

# Update system
sudo dnf update -y

# Install required packages
sudo dnf install -y tmux git tree telnet mariadb105 redis6

# Enable and start Redis
sudo systemctl enable redis6
sudo systemctl start redis6

# Connect to MySQL and execute SQL commands
mysql -h dev-rds.konkas.tech -u admin -p'Chowdary2' <<EOF
CREATE DATABASE IF NOT EXISTS crud_app;
USE crud_app;

CREATE TABLE IF NOT EXISTS entries (
  id INT AUTO_INCREMENT PRIMARY KEY,
  amount INT NOT NULL,
  description VARCHAR(255) NOT NULL
);

CREATE USER IF NOT EXISTS 'crud'@'%' IDENTIFIED BY 'CrudApp@1';
GRANT ALL ON crud_app.* TO 'crud'@'%';
FLUSH PRIVILEGES;
EOF
echo "MySQL database and user setup completed................."