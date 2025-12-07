#!/bin/bash
# Before Install - Setup environment and upgrade Node.js

echo "Starting Before Install phase..."

# Check current Node.js version
echo "Current Node.js version: $(node --version 2>/dev/null || echo 'not installed')"

# Remove old Node.js installation
echo "Removing old Node.js installation..."
yum remove -y nodejs npm 2>/dev/null || true
dnf remove -y nodejs npm 2>/dev/null || true

# Clean up old installations
rm -rf /usr/bin/node /usr/bin/npm /usr/local/bin/node /usr/local/bin/npm 2>/dev/null || true

# Install Node.js 20.x using NodeSource repository
echo "Installing Node.js 20.x..."
curl -fsSL https://rpm.nodesource.com/setup_20.x | bash -

# Install Node.js and npm
if command -v dnf &> /dev/null; then
    echo "Using dnf (Amazon Linux 2023)..."
    dnf install -y nodejs
else
    echo "Using yum (Amazon Linux 2)..."
    yum install -y nodejs
fi

# Verify installation
echo "New Node.js version: $(node --version)"
echo "npm version: $(npm --version)"

# Update npm to latest version
echo "Updating npm to latest version..."
npm install -g npm@latest

echo "Final versions:"
echo "Node.js: $(node --version)"
echo "npm: $(npm --version)"

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