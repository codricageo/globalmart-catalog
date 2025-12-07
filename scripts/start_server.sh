#!/bin/bash
# Application Start - Start nginx service

echo "Starting nginx server..."

# Start and enable nginx
systemctl start nginx
systemctl enable nginx

# Reload nginx to pick up new configuration
systemctl reload nginx

# Check if nginx is running
if systemctl is-active --quiet nginx; then
    echo "SUCCESS: Nginx started successfully"
    echo "Application is now accessible"
else
    echo "ERROR: Failed to start nginx"
    systemctl status nginx
    exit 1
fi

echo "Application Start phase completed successfully"