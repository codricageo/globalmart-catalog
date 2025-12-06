#!/bin/bash
# After Install - Configure nginx for the React application

echo "Starting After Install phase..."

# Set correct ownership and permissions for deployed files
sudo chown -R nginx:nginx /var/www/html
sudo chmod -R 755 /var/www/html

# Create nginx configuration for React SPA
sudo tee /etc/nginx/conf.d/globalmart-catalog.conf > /dev/null << 'EOL'
server {
    listen 80;
    server_name _;
    root /var/www/html;
    index index.html;

    # Handle React Router
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
}
EOL

# Remove default nginx config if it exists
sudo rm -f /etc/nginx/conf.d/default.conf

# Test nginx configuration
sudo nginx -t

echo "After Install phase completed successfully"