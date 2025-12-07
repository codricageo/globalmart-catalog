#!/bin/bash
# After Install - Build React app and configure nginx

echo "Starting After Install phase..."

# Set environment variables
export PATH="/usr/local/bin:/usr/bin:/bin:$PATH"
export HOME=/root

cd /home/ec2-user/globalmart-catalog

# Ensure proper ownership
chown -R ec2-user:ec2-user /home/ec2-user/globalmart-catalog

# Install dependencies with full npm path and proper environment
echo "Installing npm dependencies..."
cd /home/ec2-user/globalmart-catalog
/usr/bin/npm install --production --no-optional --no-audit --no-fund

# Build the React application with explicit paths and environment
echo "Building React application..."
export NODE_ENV=production
/usr/bin/npm run build

# Verify build was successful
if [ ! -d "/home/ec2-user/globalmart-catalog/build" ]; then
    echo "ERROR: Build directory not found after npm run build!"
    echo "Contents of /home/ec2-user/globalmart-catalog:"
    ls -la /home/ec2-user/globalmart-catalog/
    echo "Node.js and npm versions:"
    /usr/bin/node --version
    /usr/bin/npm --version
    exit 1
fi

echo "Build successful! Build directory contents:"
ls -la /home/ec2-user/globalmart-catalog/build/

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