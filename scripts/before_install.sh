#!/bin/bash
# Before Install - Setup environment for Amazon Linux 2023

echo "Starting Before Install phase for Amazon Linux 2023..."

# Update system packages using dnf
dnf update -y

# Install Node.js 20.x and npm for Amazon Linux 2023
echo "Installing Node.js 20.x and npm..."
# Install Node.js 20 from the official repository
curl -fsSL https://rpm.nodesource.com/setup_20.x | bash -
dnf install -y nodejs

# Verify installation
echo "Node.js version: $(node --version)"
echo "npm version: $(npm --version)"

# Create symlinks for global access if needed
ln -sf /usr/bin/node /usr/local/bin/node 2>/dev/null || true
ln -sf /usr/bin/npm /usr/local/bin/npm 2>/dev/null || true

# Install nginx if not already installed
if ! command -v nginx &> /dev/null; then
    echo "Installing nginx..."
    yum install -y nginx
else
    echo "Nginx is already installed"
fi

# Stop nginx if running
systemctl stop nginx 2>/dev/null || true

# Clean up previous deployment
if [ -d "/home/ec2-user/globalmart-catalog" ]; then
    echo "Removing previous deployment..."
    rm -rf /home/ec2-user/globalmart-catalog
fi

# Create application directory
mkdir -p /home/ec2-user/globalmart-catalog
chown -R ec2-user:ec2-user /home/ec2-user/globalmart-catalog

echo "Before Install phase completed successfully"