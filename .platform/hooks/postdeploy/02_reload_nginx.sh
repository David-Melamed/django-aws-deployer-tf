#!/bin/bash

# Log function with timestamp
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a /var/log/nginx_reload.log
}

# Source environment variables and preprocess Nginx configuration
log "Loading environment variables and preparing Nginx configuration..."
source /path/to/your/env.list
export APP_DNS=$APP_DNS

# Replace variables in Nginx template and output to the actual config file
envsubst '$APP_DNS' < /etc/nginx/conf.d/swap-app.conf.template > /etc/nginx/conf.d/swap-app.conf

# Validate Nginx configuration
log "Validating Nginx configuration..."
if ! sudo nginx -t; then
    log "ERROR: Nginx configuration validation failed."
    exit 1
else
    log "Nginx configuration is valid."
fi

# Restart nginx service
log "Attempting to restart Nginx..."
if ! sudo systemctl restart nginx; then
    log "ERROR: Failed to restart Nginx. Check the service and system logs for more details."
    exit 1
else
    log "Nginx restarted successfully."
fi

# Check if Nginx is running
log "Checking Nginx status..."
NGINX_STATUS=$(systemctl is-active nginx)
log "Nginx status: $NGINX_STATUS"

# Evaluate the status
if [ "$NGINX_STATUS" = "active" ]; then
    log "Nginx is active and running."
else
    log "ERROR: Nginx is not active. Current status: $NGINX_STATUS."
    exit 1
fi