#!/bin/bash
set -e

exec > >(tee /var/log/user-data.log) 2>&1  # Log everything

%{ if os_type == "amazon" }
yum update -y
curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
yum install -y nginx nodejs git
NGINX_ROOT="/usr/share/nginx/html"
NGINX_USER="nginx"
%{ else }
apt update -y
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
apt install -y nginx nodejs git
NGINX_ROOT="/var/www/html"
NGINX_USER="www-data"
%{ endif }

systemctl enable --now nginx

cd /tmp
git clone https://github.com/pravinmishraaws/my-react-app.git
cd my-react-app
npm install
npm run build

echo $NGINX_ROOT 
echo $NGINX_USER

# Clear nginx default content and copy React build
rm -rf $NGINX_ROOT/*
cp -r build/* $NGINX_ROOT/
chown -R $NGINX_USER:$NGINX_USER $NGINX_ROOT/

systemctl restart nginx

echo "React app deployment completed"
