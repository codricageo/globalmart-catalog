#!/bin/bash
# Before Install - Prepare nginx environment

echo "Starting Before Install phase..."

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

# Create and clean web directory
mkdir -p /usr/share/nginx/html
rm -rf /usr/share/nginx/html/*

# Set proper permissions
chown -R nginx:nginx /usr/share/nginx/html
chmod -R 755 /usr/share/nginx/html

echo "Before Install phase completed successfully"