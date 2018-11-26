#!/usr/bin/env bash

#
#   Данный скрипт установит BitrixVM окружение.
#   В результате работы скрипта папка www должна заполниться дефолтными файлами (bitrixsetup.php, restore.php и прочее)
#   

echo "The installation of the Bitrix environment started. This may take some time..."

#### Производим устровку VMBitrix
sudo ./bitrix-env.sh -s -p -H centos -M 'mysql'
# sudo ./bitrix-env.sh -s -M 'mysql'

## Чиним косяки Bitrix.Env
# Частый косяк из-за неправильного DNS-сервера в офисе
printf "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null

# отрубить автоматический запуск меню для рута
sudo sed -i 's/\/opt/#\/opt/' /root/menu.sh

# Правки, связанные с вагрантом - настройки httpd
sudo sed -i 's/User bitrix/User vagrant/' /etc/httpd/conf/httpd.conf
sudo sed -i 's/Group bitrix/Group vagrant/' /etc/httpd/conf/httpd.conf
sudo service httpd restart
# Правки, связанные с вагрантом - сессии
mkdir /tmp/php_sessions
mkdir /tmp/php_sessions/www
chown vagrant:vagrant /tmp/php_sessions -R

# Включаем phar-файлы
sudo cp /etc/php.d/20-phar.ini.disabled /etc/php.d/20-phar.ini
sudo service httpd restart

# Прокидываем ssh-ключи
if [ ! -f /home/bitrix/.ssh/id_rsa ]
  then
    echo "SSH key is missing (.ssh/id_rsa)"
  else
    echo "Copy SSH key..."
    mkdir /home/vagrant/.ssh/
    cp -f /home/bitrix/.ssh/id_rsa /home/vagrant/.ssh/id_rsa
    chmod 0600 /home/vagrant/.ssh/id_rsa
fi

# Composer
echo "Installing Composer"

curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/sbin/composer

echo "Env install finished"