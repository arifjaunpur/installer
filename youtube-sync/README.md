# Install youtube-sync

* [Ubuntu](#Ubuntu)
* [CentOS](#centos)


### Ubuntu

### Install Dependencies

```
sudo apt-get update
sudo apt-get install software-properties-common vim git nginx -y
wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | sudo apt-key add -
sudo add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
sudo apt-get install -y adoptopenjdk-8-hotspot
wget https://piccolo.link/sbt-1.3.10.tgz -P /tmp && tar -xzf /tmp/sbt-1.3.10.tgz -C /tmp
```

### Clone repository

```
git clone https://github.com/RobertLemmens/youtube-sync /tmp/youtube-sync
```


### Build application

```
cd /tmp/youtube-sync
/tmp/sbt/bin/sbt
project backend
assembly
exit
```

### Create service to run application as sevice

```
mkdir /var/app && cd /var/app
cp /tmp/youtube-sync/backend/target/scala-2.12/backend-assembly-0.1.jar /var/app/youtube-sync-0.1.jar
vim /var/app/youtube-sync.sh

#!/bin/sh
java -jar /var/app/youtube-sync-0.1.jar

vim /etc/systemd/system/youtube-sync.service

[Unit]
Description=youtube-sync systemd service.
[Service]
Type=simple
ExecStart=/bin/bash /var/app/youtube-sync.sh
[Install]
WantedBy=multi-user.target


sudo systemctl daemon-reload
sudo systemctl enable youtube-sync.service
sudo systemctl start youtube-sync.service
```

### Create reverse proxy in Nginx config 

```
vim /etc/nginx/sites-enabled/default

		proxy_pass http://127.0.0.1:8080;
		proxy_http_version 1.1;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection 'upgrade';
		proxy_set_header Host $host;
		proxy_cache_bypass $http_upgrade;
    
sudo service nginx restart
```

## cleanup 

Remove SBT and youtube-sync source code

```
rm -rf /tmp/youtube-sync
rm -rf /tmp/sbt*
```

