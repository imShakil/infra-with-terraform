#!/bin/bash

set -e

exec > >(tee -a /var/log/epkbk_install.log) 2>&1 # Log everything to find the failure

echo "Installing EpicBook Application"

HOME_USER="${SSH_USER}"
PROJECT_DIR="/home/$HOME_USER/theepicbook"

apt-get update -y

# Install basic packages first
apt-get install -y nginx mysql-client git curl

# Install Node.js 18.x from NodeSource
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
apt-get install -y nodejs

systemctl enable --now nginx

echo $(node -v)
echo $(npm -v)
echo $(git --version)
echo $(nginx -v)


# clone the project
# clone the project

echo "Cloning the project"
git clone https://github.com/pravinmishraaws/theepicbook.git $PROJECT_DIR || {
    echo "Git clone failed!"
    exit 1
}

chown -R $HOME_USER:$HOME_USER $PROJECT_DIR

cd $PROJECT_DIR || {
    echo "Failed to change directory to $PROJECT_DIR"
    exit 1
}

# install dependencies
echo "Installing dependencies"
npm install

# Add debugging before MySQL commands
echo "DB_HOST: ${DB_HOST}"
echo "DB_USER: ${DB_USER}" 
echo "DB_NAME: ${DB_NAME}"
echo "Testing database connection..."

# Test connection first
export MYSQL_PWD="${DB_PASSWORD}"
mysql -h "${DB_HOST}" -u "${DB_USER}" -e "SELECT 1;" || {
    echo "Database connection failed!"
    exit 1
}

# import data into database
echo "Importing data into database"
set +e  # Disable exit on error for MySQL imports

mysql -h "${DB_HOST}" -u "${DB_USER}" "${DB_NAME}" < db/BuyTheBook_Schema.sql || echo "Schema import completed (some tables may already exist)"
mysql -h "${DB_HOST}" -u "${DB_USER}" "${DB_NAME}" < db/author_seed.sql || echo "Author seed import completed (data may already exist)"
mysql -h "${DB_HOST}" -u "${DB_USER}" "${DB_NAME}" < db/books_seed.sql || echo "Books seed import completed (data may already exist)"

set -e  # Re-enable exit on error
echo "Database import section completed"

# create new config with SSL
echo "Updating config file"

cat > config/config.json << EOF
{
  "development": {
    "username": "${DB_USER}",
    "password": "${DB_PASSWORD}", 
    "database": "${DB_NAME}",
    "host": "${DB_HOST}",
    "dialect": "mysql",
    "dialectOptions": {
      "ssl": {
        "require": true,
        "rejectUnauthorized": false
      }
    }
  }
} 
EOF

# Updating nginx config

tee /etc/nginx/sites-available/default > /dev/null <<'EOF'
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://localhost:8080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
EOF

systemctl restart nginx

# Starting the application

echo "Everything is done, starting the application"

cat <<EOF >/etc/systemd/system/epicbook.service
[Unit]
Description=EpicBook Node.js App
After=network.target

[Service]
User=$HOME_USER
WorkingDirectory=$PROJECT_DIR
ExecStart=/usr/bin/npm start
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable epicbook
systemctl start epicbook
