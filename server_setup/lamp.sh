#!/bin/bash
# a shell script to quickly install a lamp stack
# known to work on Ubuntu 16.04+
#
# Version 0.1
# September 15, 2017
# 
# Created by bmcculley
# licensed under a Creative Commons Attribution 4.0 International License

# update the repositories
sudo apt update

# install apache
sudo apt install -y apache2

# if you are planning to use this as a production server other settings 
# should be configured

# from here you might want to configure virtual hosts
echo "Would you like to create a virtual host? [y/N]"
read ans
fl=${ans:0:1}

if [ "${fl,,}" = "y" ]
then
    echo "Please enter the name of the site you would like to create (example.com): "
    read site_name
    
read -r -d '' vhost << EOM
    <Directory /var/www/html/${site_name}/public_html>
        Require all granted
    </Directory>
    <VirtualHost *:80>
            ServerName ${site_name}
            ServerAlias www.${site_name}
            ServerAdmin webmaster@localhost
            DocumentRoot /var/www/html/${site_name}/public_html

            ErrorLog /var/www/html/${site_name}/logs/error.log
            CustomLog /var/www/html/${site_name}/logs/access.log combined

    </VirtualHost>
EOM

    # write this to a file
    echo "${vhost}" | sudo tee --append /etc/apache2/sites-available/${site_name}.conf > /dev/null

    # create the directories for the site
    sudo mkdir -p /var/www/html/${site_name}/{public_html,logs}

    # enable the site
    sudo a2ensite ${site_name}.conf

    # reload apache so the changes are picked up
    sudo systemctl reload apache2
fi

# install mysql
sudo apt install -y mysql-server

# from here you'll want to harden the installation and probably create
# some databases

# install PHP
sudo apt install -y php7.0 libapache2-mod-php7.0 php7.0-mysql php7.0-mcrypt

echo "Would you like to install PHP CuRL too? [y/N]"
read ci
fl_ci=${ci:0:1}

if [ "${fl_ci,,}" = "y" ]
then
    sudo apt install -y php7.0-curl
fi

# restart apache
sudo systemctl restart apache2

echo "Would you like to create a PHP info page to check the install? [y/N]"
read php_ci
fl_php_ci=${php_ci:0:1}

if [ "${fl_php_ci,,}" = "y" ]
then
    echo "<?php phpinfo(); ?>" | sudo tee --append /var/www/html/${site_name}/public_html/test.php > /dev/null
    echo "Ok open http://${site_name}/test.php in your browser to check."
    echo "Done checking? [Y/n]"
    read dc
    fl_dc=${dc:0:1}

    if [ "${fl_dc,,}" != "n" ]
    then
        rm /var/www/html/${site_name}/public_html/test.php
    fi
fi