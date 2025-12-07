#!/bin/bash
# Application Start - Start nginx service

echo "Starting nginx server..."

# Start and enable nginx
systemctl start nginx
systemctl enable nginx

# Wait a moment for nginx to start
sleep 2

# Check if nginx is running
if systemctl is-active --quiet nginx; then
    echo "✓ SUCCESS: Nginx started successfully"
    echo "✓ Application should now be accessible on port 80"
    
    # Show nginx status
    systemctl status nginx --no-pager -l
    
    # Test local connection
    echo "Testing local connection..."
    if curl -s http://localhost/ | grep -q "html"; then
        echo "✓ Local HTTP test successful"
    else
        echo "⚠ Local HTTP test failed, but nginx is running"
    fi
else
    echo "✗ ERROR: Failed to start nginx"
    systemctl status nginx --no-pager -l
    echo "Nginx error log:"
    tail -20 /var/log/nginx/error.log 2>/dev/null || echo "No error log found"
    exit 1
fi

echo "Application Start phase completed successfully"