#!/bin/sh
# In The Name Of God
# ========================================
# [] File Name : php.sh
#
# [] Creation Date : 29-07-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
sudo apt install php-cli php-xml
# setup composer
if [ ! -e /usr/local/bin/composer ]; then
	curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
	sudo chown -R $USER:$USER $HOME/.composer
fi
# setup phpcs globally
composer global require "squizlabs/php_codesniffer=*"
phpcs --config-set default_standard PSR2
# setup phpdoc globally
sudo apt install php-intl php-xsl
composer global require "phpdocumentor/phpdocumentor"