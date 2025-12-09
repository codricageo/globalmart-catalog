#!/bin/bash
# cache_control.sh - Automatic cache management for deployment

echo "🔄 Starting cache control automation..."

# Set cache-busting headers in nginx
cat > /etc/nginx/conf.d/cache-control.conf << 'EOF'
# React SPA Cache Control Configuration

# Static assets with versioning (JS/CSS) - cache for 1 year
location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
    expires 1y;
    add_header Cache-Control "public, immutable";
    add_header X-Content-Type-Options "nosniff";
    
    # ETag for better cache validation
    etag on;
    
    # Serve pre-compressed files if available
    gzip_static on;
}

# HTML files - no cache (always fresh)
location ~* \.(html)$ {
    expires -1;
    add_header Cache-Control "no-cache, no-store, must-revalidate";
    add_header Pragma "no-cache";
    add_header X-Content-Type-Options "nosniff";
    
    # Disable ETag for HTML
    etag off;
}

# API endpoints - no cache
location /api/ {
    expires -1;
    add_header Cache-Control "no-cache, no-store, must-revalidate";
    add_header Pragma "no-cache";
}

# Add deployment info header
add_header X-Deployment-Time "$(date -Iseconds)";
add_header X-Server-Info "GlobalMart-EC2-AutoDeploy";
EOF

echo "✅ Nginx cache control configured"

# Clear browser cache hints by adding deployment timestamp to index.html
DEPLOYMENT_TIME=$(date +"%Y%m%d-%H%M%S")
sed -i "s/<meta name=\"deployment-time\" content=\"[^\"]*\">/<meta name=\"deployment-time\" content=\"$DEPLOYMENT_TIME\">/g" /usr/share/nginx/html/index.html

# Add deployment meta tag if it doesn't exist
if ! grep -q "deployment-time" /usr/share/nginx/html/index.html; then
    sed -i '/<meta name="theme-color"/a\    <meta name="deployment-time" content="'$DEPLOYMENT_TIME'">' /usr/share/nginx/html/index.html
fi

echo "✅ Deployment timestamp added to HTML"

# Reload nginx configuration
nginx -t && systemctl reload nginx

echo "✅ Nginx reloaded with new cache settings"
echo "🎉 Cache control automation completed!"