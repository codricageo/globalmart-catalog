#!/bin/bash
# Start Server - Start the nginx service and ensure it's running

echo "Starting Application Server..."

# Start and enable nginx
systemctl start nginx
systemctl enable nginx

# Reload nginx to pick up new configuration
systemctl reload nginx

# Check if nginx is running
if systemctl is-active --quiet nginx; then
    echo "Nginx started successfully"
else
    echo "Failed to start nginx"
    exit 1
fi

echo "Application server started successfully"