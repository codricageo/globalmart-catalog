#!/bin/bash
# Start Server - Start nginx service

echo "Starting nginx server..."

# Start and enable nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Reload nginx to pick up new configuration
sudo systemctl reload nginx

# Check if nginx is running
if sudo systemctl is-active --quiet nginx; then
    echo "Nginx started successfully"
else
    echo "Failed to start nginx"
    exit 1
fi

echo "Application server started successfully"