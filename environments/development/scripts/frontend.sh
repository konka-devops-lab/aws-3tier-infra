#!/bin/bash
aws s3 cp s3://vm-s3-nginx-conf/nginx.conf /etc/nginx/nginx.conf
systemctl restart nginx

# set -euxo pipefail

# # Install tools needed
# yum install -y awscli nmap-ncat  # <-- installs nc

# # Pull nginx config
# aws s3 cp s3://vm-s3-nginx-conf/nginx.conf /etc/nginx/nginx.conf

# # Restart nginx
# systemctl restart nginx

# # Wait until NGINX is up and listening on port 80
# for i in {1..10}; do
#   if nc -z localhost 80; then
#     echo "✅ NGINX is ready"
#     break
#   fi
#   echo "⏳ Waiting for NGINX... ($i)"
#   sleep 5
# done
