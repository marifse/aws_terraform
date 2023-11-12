#! /bin/bash

sudo apt-get update -y
sudo apt install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx
sudo chmod 777 /var/www/html/
sudo export INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
sudo echo "<html><body><h1>Hello to Test WebApp at instance <b>"$INSTANCE_ID"</b></h1></body></html>" > /var/www/html/index.html

