#!/bin/bash
# Before Install - Setup environment and install dependencies

echo "Starting Before Install phase..."

# Update system packages
yum update -y

# Install Node.js 18.x if not already installed
if ! command -v node &> /dev/null; then
    echo "Installing Node.js..."
    curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
    yum install -y nodejs
else
    echo "Node.js is already installed: $(node --version)"
fi

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