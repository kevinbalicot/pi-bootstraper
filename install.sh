#!/bin/bash

echo "Update packages"
sudo apt-get update

echo "Install vim"
sudo apt-get install -y vim

echo "Install docker"
curl -sSL https://get.docker.com | sh
sudo docker ps

echo "Install sickrage"
sudo docker create --name=sickrage \
    -v ~/config/sickrage:/config \
    -v /mnt/downloads:/downloads \
    -v /mnt/videos:/tv \
    -p 8080:8081 \
    -e PGID=1000 \
    -e PUID=1000 \
    lsioarmhf/sickrage

sudo docker start sickrage

echo "Install transmission"
sudo docker create --name=transmission \
    -v ~/config/transmission:/config \
    -v /mnt/downloads:/downloads \
    -v ~/watch:/watch \
    -p 9090:9091 -p 51413:51413 \
    -p 51413:51413/udp \
    -e PGID=1000 \
    -e PUID=1000 \
    lsioarmhf/transmission

sudo docker start transmission

echo "Install samba"
sudo docker run -d -p 445:445 \
    -v /mnt:/share/data \
    --name samba trnape/rpi-samba \
    -u "pi:raspberry" \
    -s "Pi (private):/share/data:rw:pi"

echo "Try to mount USB hard disk"
sudo mount -t ntfs /dev/sda1 /mnt -o umask=0022 -o uid=1000 -o gid=1000
