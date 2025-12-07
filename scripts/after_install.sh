#!/bin/bash
# After Install - Build React app and configure nginx

echo "Starting After Install phase..."

cd /home/ec2-user/globalmart-catalog

# Ensure proper ownership
chown -R ec2-user:ec2-user /home/ec2-user/globalmart-catalog

# Install npm dependencies as ec2-user
echo "Installing npm dependencies..."
su - ec2-user -c "cd /home/ec2-user/globalmart-catalog && npm ci --only=production"

# Build the React application as ec2-user
echo "Building React application..."
su - ec2-user -c "cd /home/ec2-user/globalmart-catalog && npm run build"

# Check if build was successful
if [ ! -d "/home/ec2-user/globalmart-catalog/build" ]; then
    echo "ERROR: Build directory not found!"
    exit 1
fi

# Create nginx web root and copy build files
echo "Deploying build files to nginx..."
mkdir -p /usr/share/nginx/html
rm -rf /usr/share/nginx/html/*
cp -r /home/ec2-user/globalmart-catalog/build/* /usr/share/nginx/html/

# Set proper permissions for nginx
chown -R nginx:nginx /usr/share/nginx/html
chmod -R 755 /usr/share/nginx/html

# Configure nginx for React SPA
cat > /etc/nginx/conf.d/globalmart-catalog.conf << 'EOL'
server {
    listen 80;
    server_name _;
    root /usr/share/nginx/html;
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

# Remove default nginx config
rm -f /etc/nginx/conf.d/default.conf
rm -f /etc/nginx/sites-enabled/default

# Test nginx configuration
nginx -t

echo "After Install phase completed successfully"