apt update
apt -y upgrade
apt install -y ruby-full ruby-bundler build-essential git mongodb

mkdir /app && cd /app/
git clone -b monolith https://github.com/express42/reddit.git
#mkdir /app && mv reddit /app/ &&
cd /app/reddit && bundle install

cat <<EOF >  reddit-app.service
[Unit]
Description="Reddit App"
After=network.target

[Service]
Type=simple
WorkingDirectory=/app/reddit
ExecStart=/usr/local/bin/puma

[Install]
WantedBy=multi-user.target
EOF

mv reddit-app.service  /etc/systemd/system/

#добавляем в автозапуск

systemctl daemon-reload
systemctl start mongodb
systemctl enable mongodb


systemctl start reddit-app.service
systemctl enable reddit-app.service
