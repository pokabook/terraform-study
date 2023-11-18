#!/bin/bash

sudo sed -i 's/#Port 22/Port 4272/' /etc/ssh/sshd_config
sudo systemctl restart sshd

sudo yum install git -y
