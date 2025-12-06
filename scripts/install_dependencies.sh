#!/bin/bash
# Install dependencies for the React application

# Update system packages
yum update -y

# Install Node.js and npm if not already installed
curl -sL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs

# Install PM2 globally for process management
npm install -g pm2

# Install nginx if not already installed
yum install -y nginx

# Create application directory if it doesn't exist
mkdir -p /var/www/html/globalmart-catalog

# Set proper permissions
chown -R www-data:www-data /var/www/html/globalmart-catalog
chmod -R 755 /var/www/html/globalmart-catalog

echo "Dependencies installed successfully"