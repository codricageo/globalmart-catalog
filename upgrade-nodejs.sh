#!/bin/bash
# Manual Node.js upgrade script for EC2 instance
# Run this on your EC2 instance: sudo bash upgrade-nodejs.sh

echo "=== Node.js Upgrade Script for EC2 ==="

# Check current version
echo "Current Node.js version: $(node --version 2>/dev/null || echo 'not installed')"
echo "Current npm version: $(npm --version 2>/dev/null || echo 'not installed')"

# Remove old Node.js installations
echo "Removing old Node.js installations..."
yum remove -y nodejs npm 2>/dev/null || true
dnf remove -y nodejs npm 2>/dev/null || true

# Clean up old binaries
rm -rf /usr/bin/node /usr/bin/npm /usr/local/bin/node /usr/local/bin/npm 2>/dev/null || true

# Install Node.js 20.x from NodeSource
echo "Adding NodeSource repository..."
curl -fsSL https://rpm.nodesource.com/setup_20.x | bash -

# Install Node.js
if command -v dnf &> /dev/null; then
    echo "Installing Node.js with dnf..."
    dnf install -y nodejs
else
    echo "Installing Node.js with yum..."
    yum install -y nodejs
fi

# Update npm to latest
echo "Updating npm to latest version..."
npm install -g npm@latest

# Verify installation
echo ""
echo "=== Installation Complete ==="
echo "Node.js version: $(node --version)"
echo "npm version: $(npm --version)"
echo "Node.js location: $(which node)"
echo "npm location: $(which npm)"

echo ""
echo "✓ Node.js upgrade completed successfully!"
echo "You can now run your CodeDeploy deployment."