#!/bin/bash
# Validate that the service is running correctly

# Check if nginx is running
if ! systemctl is-active --quiet nginx; then
    echo "ERROR: Nginx is not running"
    exit 1
fi

# Check if the application is accessible
if ! curl -f -s http://localhost/ > /dev/null; then
    echo "ERROR: Application is not accessible"
    exit 1
fi

# Check if build directory exists and has files
if [ ! -d "/var/www/html/globalmart-catalog/build" ]; then
    echo "ERROR: Build directory does not exist"
    exit 1
fi

if [ ! -f "/var/www/html/globalmart-catalog/build/index.html" ]; then
    echo "ERROR: index.html not found in build directory"
    exit 1
fi

echo "Service validation successful"
exit 0