#!/bin/bash
# Validate Service - Check if the application is running correctly

echo "Validating service deployment..."

# Check if nginx is running
if ! systemctl is-active --quiet nginx; then
    echo "ERROR: Nginx is not running"
    exit 1
fi

# Check nginx configuration
if ! nginx -t; then
    echo "ERROR: Nginx configuration is invalid"
    exit 1
fi

# Check if web root exists and has content
if [ ! -d "/var/www/html" ]; then
    echo "ERROR: Web root directory does not exist"
    exit 1
fi

if [ ! -f "/var/www/html/index.html" ]; then
    echo "ERROR: index.html not found in web root"
    exit 1
fi

# Wait a moment for nginx to fully start
sleep 3

# Check if the application is accessible on localhost
if curl -f -s http://localhost/ > /dev/null; then
    echo "SUCCESS: Application is accessible via HTTP"
else
    echo "WARNING: Application may not be accessible via HTTP"
fi

echo "Service validation completed successfully"
exit 0