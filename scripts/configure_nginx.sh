#!/bin/bash
# Configure nginx for React SPA

echo "Configuring nginx for React application..."

# Verify files were deployed
echo "Checking deployed files in /var/www/html:"
ls -la /var/www/html/

# Set proper permissions for deployed files
chown -R nginx:nginx /var/www/html
chmod -R 755 /var/www/html

# Backup default nginx config
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup 2>/dev/null || true

# Create nginx configuration for React SPA
cat > /etc/nginx/conf.d/globalmart-catalog.conf << 'EOL'
server {
    listen 80;
    server_name _;
    root /var/www/html;
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

# Remove or disable default nginx configurations
rm -f /etc/nginx/conf.d/default.conf
rm -f /etc/nginx/sites-enabled/default

# For Amazon Linux 2023, also disable the default server block in main config
sed -i '/server {/,/^}/s/^/#/' /etc/nginx/nginx.conf 2>/dev/null || true

# Test nginx configuration
echo "Testing nginx configuration..."
nginx -t

if [ $? -eq 0 ]; then
    echo "✓ Nginx configuration is valid"
else
    echo "✗ ERROR: Nginx configuration is invalid"
    cat /etc/nginx/conf.d/globalmart-catalog.conf
    exit 1
fi

# Final verification
echo "Final verification - files in web root:"
ls -la /var/www/html/
echo "React app index.html preview:"
head -5 /var/www/html/index.html 2>/dev/null || echo "index.html not found!"

echo "Nginx configuration completed successfully"