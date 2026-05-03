#!/bin/bash

COMPONENT=$1
PROJECT=$2
ENV=$3
ZONE=$4
sudo dnf install ansible -y
sudo mkdir -p /var/log/roboshop
sudo touch /var/log/roboshop/ansible.log
sudo chmod 666 /var/log/roboshop/ansible.log
sudo ansible-pull -U https://github.com/vija-web/ansible_for_tf.git -C main -e "component=$COMPONENT" -e "project=$PROJECT" -e "env=$ENV" -e "zone=$ZONE" main.yaml