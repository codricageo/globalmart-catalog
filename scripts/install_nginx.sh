#!/bin/bash
# Install Nginx and prepare environment for Amazon Linux 2023

echo "Installing and configuring nginx on Amazon Linux 2023..."

# Update system and install nginx using dnf
dnf update -y
dnf install -y nginx

# Stop nginx if running
systemctl stop nginx 2>/dev/null || true

# Create web directory and clean it
mkdir -p /var/www/html
rm -rf /var/www/html/*

# Ensure proper ownership
chown -R nginx:nginx /var/www/html

echo "Nginx installation completed"