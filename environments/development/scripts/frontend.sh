#!/bin/bash
aws s3 cp s3://vm-s3-nginx-conf/nginx.conf /etc/nginx/nginx.conf
systemctl restart nginx