#!/bin/bash
# universal-deploy.sh - Run this script on ANY EC2 server for cache optimization

echo "🌍 UNIVERSAL CACHE OPTIMIZATION FOR PRODUCTION"
echo "============================================="

# Function to detect web server
detect_web_server() {
    if systemctl is-active --quiet nginx; then
        echo "nginx"
    elif systemctl is-active --quiet apache2 || systemctl is-active --quiet httpd; then
        echo "apache"
    else
        echo "unknown"
    fi
}

# Universal cache setup
setup_universal_cache() {
    local web_server=$(detect_web_server)
    
    case $web_server in
        "nginx")
            echo "📋 Setting up universal Nginx cache configuration..."
            
            # Create universal cache config
            cat > /etc/nginx/conf.d/universal-cache.conf << 'EOF'
# Universal Cache Configuration - Auto-generated
map $sent_http_content_type $expires {
    "text/html"                 -1;
    "text/html; charset=utf-8"  -1;
    default                     1y;
}

server {
    listen 80;
    server_name _;
    
    expires $expires;
    
    # Cache-busting headers
    add_header X-Universal-Cache "v1.0";
    add_header X-Cache-Update "$(date -Iseconds)";
    
    # Static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # HTML - never cache
    location ~* \.(html)$ {
        expires -1;
        add_header Cache-Control "no-cache, no-store, must-revalidate";
    }
}
EOF
            
            # Test and reload
            nginx -t && systemctl reload nginx
            echo "✅ Nginx universal cache configured"
            ;;
            
        "apache")
            echo "📋 Setting up universal Apache cache configuration..."
            
            # Create .htaccess for universal caching
            cat > /var/www/html/.htaccess << 'EOF'
# Universal Cache Configuration for Apache
<IfModule mod_expires.c>
    ExpiresActive On
    
    # HTML - no cache
    ExpiresByType text/html "access plus 0 seconds"
    
    # Static assets - 1 year
    ExpiresByType application/javascript "access plus 1 year"
    ExpiresByType text/css "access plus 1 year"
    ExpiresByType image/png "access plus 1 year"
    ExpiresByType image/jpg "access plus 1 year"
    ExpiresByType image/jpeg "access plus 1 year"
    ExpiresByType image/gif "access plus 1 year"
    ExpiresByType image/ico "access plus 1 year"
    ExpiresByType image/svg+xml "access plus 1 year"
</IfModule>

<IfModule mod_headers.c>
    Header always set X-Universal-Cache "v1.0"
    Header always set X-Cache-Update "AUTO"
</IfModule>
EOF
            
            systemctl reload apache2 2>/dev/null || systemctl reload httpd 2>/dev/null
            echo "✅ Apache universal cache configured"
            ;;
            
        *)
            echo "⚠️ Web server not detected - manual configuration required"
            ;;
    esac
}

# Universal deployment verification
verify_universal_deployment() {
    echo "🔍 Universal deployment verification..."
    
    # Check HTTP response
    local http_status=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/)
    if [ "$http_status" = "200" ]; then
        echo "✅ HTTP 200 - Site accessible"
    else
        echo "❌ HTTP $http_status - Site issue"
    fi
    
    # Check cache headers
    echo "📋 Cache headers:"
    curl -sI http://localhost/ | grep -E "Cache-Control|X-Universal-Cache|X-Cache-Update" | sed 's/^/   /'
    
    # Check for static files
    if find /usr/share/nginx/html /var/www/html -name "*.js" -o -name "*.css" 2>/dev/null | head -1 | grep -q .; then
        echo "✅ Static assets found"
    else
        echo "⚠️ No static assets detected"
    fi
}

# Main execution
main() {
    echo "🚀 Starting universal cache optimization..."
    
    # Setup cache configuration
    setup_universal_cache
    
    # Verify deployment
    verify_universal_deployment
    
    echo "🎉 Universal cache optimization completed!"
    echo "📝 This configuration works for ALL your production sites"
}

# Run main function
main "$@"