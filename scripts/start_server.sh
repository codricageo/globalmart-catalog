#!/bin/bash
# Start the React application

cd /var/www/html/globalmart-catalog

# Install npm dependencies
npm install

# Build the React application
npm run build

# Start nginx service
systemctl start nginx
systemctl enable nginx

# Configure nginx to serve the React build
cat > /etc/nginx/sites-available/globalmart-catalog << 'EOL'
server {
    listen 80;
    server_name _;
    root /var/www/html/globalmart-catalog/build;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location /static/ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOL

# Enable the site
ln -sf /etc/nginx/sites-available/globalmart-catalog /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# Test nginx configuration
nginx -t

# Reload nginx
systemctl reload nginx

echo "Application started successfully"