#!/bin/bash

#Install docker and pull drone images
sudo yum update -y 
sudo amazon-linux-extras install docker -y
sudo systemctl enable docker
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo docker info 
sudo docker pull drone/drone:1
sudo docker pull drone/drone-runner-docker:1

#Install certbot
sudo yum install -y wget
cd /tmp
wget -O epel.rpm –nv https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y ./epel.rpm
sudo yum install -y python2-certbot-apache.noarch
