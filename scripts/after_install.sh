#!/bin/bash
# After Install - Configure nginx for React SPA

echo "Starting After Install phase..."

# Verify files were deployed
echo "Checking deployed files:"
ls -la /usr/share/nginx/html/

# Set proper ownership and permissions
chown -R nginx:nginx /usr/share/nginx/html
chmod -R 755 /usr/share/nginx/html

# Create nginx configuration for React SPA
echo "Configuring nginx for React application..."
cat > /etc/nginx/conf.d/globalmart-catalog.conf << 'EOL'
server {
    listen 80;
    server_name _;
    root /usr/share/nginx/html;
    index index.html;

    # Handle React Router - serve index.html for all routes
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Cache static assets
    location /static/ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json;
}
EOL

# Remove default nginx config
rm -f /etc/nginx/conf.d/default.conf

# Test nginx configuration
nginx -t
if [ $? -eq 0 ]; then
    echo "✓ Nginx configuration is valid"
else
    echo "✗ Nginx configuration error"
    exit 1
fi

# Start nginx
systemctl start nginx
systemctl enable nginx

# Verify nginx is running
if systemctl is-active --quiet nginx; then
    echo "✓ Nginx started successfully"
    echo "✓ React application deployed successfully!"
else
    echo "✗ Failed to start nginx"
    exit 1
fi

echo "After Install phase completed successfully"