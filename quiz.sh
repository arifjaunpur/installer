apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y && apt-get autoclean -y && apt-get autoremove -y
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y build-essential git nginx nodejs mysql-server
rm -rf /etc/nginx/sites-enabled/default && cat >/etc/nginx/sites-enabled/default <<EOL
server {
  listen 80 default_server;
  listen [::]:80 default_server;
  server_name _;
  root /var/www/html;
  index index.html index.htm index.nginx-debian.html;
  location /api {
    proxy_pass http://localhost:8080;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host $host;
    proxy_cache_bypass $http_upgrade;
  }
  location / {
    try_files $uri /index.html =404;
  }
}
EOL
mkdir -p /var/app && cd /var/app
git clone https://mak786mak7@bitbucket.org/mak786mak7/quiz_frontend.git
git clone https://mak786mak7@bitbucket.org/mak786mak7/quiz_backend.git
cd quiz_frontend/
sudo npm i
API_URL=/api/v1/ npm run build
rm -rf /var/www/html/ && cp -r build/ /var/www/html/
cd ../quiz_backend/
sudo npm i
sed -i '1iNODE_ENV=production\nPORT=3000' /etc/environment
export NODE_ENV=production
export PORT=3000
npm i -g pm2
sudo mysql_secure_installation
mysql -uroot -p
#create database quiz;
#mysql -uroot -p quiz < db.sql
pm2 start app.js
