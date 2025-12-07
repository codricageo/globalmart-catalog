#!/bin/bash
# Install Nginx and prepare environment

echo "Installing and configuring nginx..."

# Update system packages
if command -v dnf &> /dev/null; then
    echo "Using dnf (Amazon Linux 2023)..."
    dnf update -y
    dnf install -y nginx
else
    echo "Using yum (Amazon Linux 2)..."
    yum update -y
    yum install -y nginx
fi

# Stop nginx if running
systemctl stop nginx 2>/dev/null || true

# Create web directory and clean it
mkdir -p /var/www/html
rm -rf /var/www/html/*

# Ensure proper ownership
chown -R nginx:nginx /var/www/html

echo "Nginx installation completed"