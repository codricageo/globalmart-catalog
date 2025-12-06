#!/bin/bash
# Stop the application services

# Stop nginx if running
if systemctl is-active --quiet nginx; then
    systemctl stop nginx
    echo "Nginx stopped"
fi

# Kill any node processes that might be running
pkill -f node

echo "Application stopped successfully"