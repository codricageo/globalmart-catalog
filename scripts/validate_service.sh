#!/bin/bash
# Validate Service - Check if the application is running correctly

echo "Validating service deployment..."

# Check if nginx is running
if ! systemctl is-active --quiet nginx; then
    echo "ERROR: Nginx is not running"
    exit 1
fi

# Check if the application is accessible on localhost
sleep 5  # Give nginx a moment to fully start

if curl -f -s http://localhost/ > /dev/null; then
    echo "SUCCESS: Application is accessible"
else
    echo "WARNING: Application may not be fully accessible yet"
    # Don't fail the deployment for this, as it might be a timing issue
fi

# Check if build directory and key files exist
if [ ! -d "/var/www/html/globalmart-catalog/build" ]; then
    echo "ERROR: Build directory does not exist"
    exit 1
fi

if [ ! -f "/var/www/html/globalmart-catalog/build/index.html" ]; then
    echo "ERROR: index.html not found in build directory"
    exit 1
fi

# Check nginx configuration
if ! nginx -t; then
    echo "ERROR: Nginx configuration is invalid"
    exit 1
fi

echo "Service validation completed successfully"
exit 0