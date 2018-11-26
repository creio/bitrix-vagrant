#!/usr/bin/env bash

sudo yum -y update
sudo yum -y install wget
sudo yum -y install nano
sudo wget http://repos.1c-bitrix.ru/yum/bitrix-env.sh

sudo chmod +x bitrix-env.sh

# Выключаем дерективу SElinux
sudo sed -i 's/enforcing/disabled/g' /etc/selinux/config /etc/selinux/config

echo "Virtual machine will reboot"