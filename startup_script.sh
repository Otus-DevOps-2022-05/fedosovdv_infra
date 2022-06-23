#!/bin/sh
sudo apt update
sudo apt install -y ruby-full ruby-bundler build-essential git mongodb
sudo systemctl start mongodb
sudo systemctl enable mongodb
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
puma -d
ps aux | grep puma | grep -v grep
