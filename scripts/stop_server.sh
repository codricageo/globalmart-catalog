#!/bin/bash
# Stop Server - Stop nginx service

echo "Stopping nginx service..."

# Stop nginx service
if sudo systemctl is-active --quiet nginx; then
    sudo systemctl stop nginx
    echo "Nginx service stopped"
fi

echo "Application services stopped successfully"