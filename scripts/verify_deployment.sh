#!/bin/bash
# verify_deployment.sh - Automated deployment verification

echo "🔍 AUTOMATED DEPLOYMENT VERIFICATION"
echo "=================================="

# Check deployment timestamp
DEPLOYMENT_TIME=$(date +"%Y-%m-%d %H:%M:%S")
echo "📅 Verification Time: $DEPLOYMENT_TIME"

# Check JavaScript files
echo "📄 JavaScript Files:"
ls -la /usr/share/nginx/html/static/js/main.*.js | while read line; do
    echo "   $line"
done

# Check for cache-busting content
echo "🔄 Cache-Busting Verification:"
if strings /usr/share/nginx/html/static/js/main.*.js | grep -q "DEPLOYMENT INFO"; then
    echo "   ✅ Cache-busting content found"
else
    echo "   ❌ Cache-busting content missing"
fi

# Check build info
echo "🔨 Build Information:"
BUILD_INFO=$(strings /usr/share/nginx/html/static/js/main.*.js | grep -E "Build:|Commit:|Pipeline:" | head -3)
if [ -n "$BUILD_INFO" ]; then
    echo "$BUILD_INFO" | sed 's/^/   /'
else
    echo "   ❌ Build info not found"
fi

# Test HTTP response
echo "🌐 HTTP Response Test:"
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/)
if [ "$HTTP_STATUS" = "200" ]; then
    echo "   ✅ HTTP 200 - Site accessible"
else
    echo "   ❌ HTTP $HTTP_STATUS - Site issue"
fi

# Check nginx cache headers
echo "📋 Cache Headers:"
curl -sI http://localhost/ | grep -E "Cache-Control|X-Deployment-Time" | sed 's/^/   /'

# Final verification
echo "🎯 Final Check:"
if grep -q "EcomerceWebsite JSTest" /usr/share/nginx/html/static/js/main.*.js 2>/dev/null; then
    echo "   ✅ Latest content deployed successfully!"
    echo "   🚀 Deployment verification PASSED"
    exit 0
else
    echo "   ❌ Latest content not found"
    echo "   💥 Deployment verification FAILED"
    exit 1
fi