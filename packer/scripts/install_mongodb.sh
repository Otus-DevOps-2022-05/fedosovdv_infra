#!/bin/sh

# wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
# echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodborg/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list

###<<<https://repo.mongodb.org/apt/ubuntu/dists/xenial/mongodb-org/4.2/InRelease  403  Forbidden >>>

sudo apt update

sudo apt install -y mongodb

sudo systemctl start mongodb
sudo systemctl enable mongodb
