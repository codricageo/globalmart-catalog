#!/bin/bash
# Before Install - Prepare the environment for deployment

echo "Starting Before Install phase..."

# Update system packages
yum update -y

# Install Node.js 18.x if not already installed
if ! command -v node &> /dev/null; then
    curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
    yum install -y nodejs
fi

# Install nginx if not already installed
if ! command -v nginx &> /dev/null; then
    yum install -y nginx
fi

# Stop any existing services
systemctl stop nginx 2>/dev/null || true

# Remove any existing application files
if [ -d "/home/ec2-user/globalmart-catalog" ]; then
    echo "Removing existing application files..."
    rm -rf /home/ec2-user/globalmart-catalog
fi

# Create application directory
mkdir -p /home/ec2-user/globalmart-catalog

# Set proper ownership
chown -R ec2-user:ec2-user /home/ec2-user/globalmart-catalog

echo "Before Install phase completed successfully"