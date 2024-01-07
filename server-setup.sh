#!/usr/bin/bash

function echo_section_header() {
    echo "------------------------------------------------------------"
    echo "$1..."
    echo "------------------------------------------------------------"
    sleep 3
}


function setup_ufu() {
    sudo ufw allow 'Nginx Full'
    sudo ufw allow 'OpenSSH'
    sudo ufw delete allow 'Nginx HTTP'
    sudo ufw --force enable

}

echo_section_header "Welcome to the SupportManager server setup script"

git clone git@github.com:TomEasterbrook/support-manager-web.git

echo "Welcome to the SupportManager the server setup script
This script will install all the required dependencies for the SupportManager to run"

read -p "Press enter to continue"





sed -i "s/#\$nrconf{restart} = 'i';/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf

echo_section_header "Updating system"
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update

echo_section_header "Installing PHP"
sudo apt install php8.3 php8.3-cli php8.3-{bz2,curl,fpm,mbstring,mysql,redis,intl,xml,zip} -y

echo_section_header "Installing Composer"
sudo curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

echo_section_header "Installing NodeJS"
sudo apt install nodejs npm -y
npm install -g n
sudo n stable

echo_section_header "Installing Supervisor"
sudo apt install supervisor -y

echo_section_header "Installing Nginx"
sudo apt install nginx -y

echo_section_header "Installing Certbot"
sudo apt install certbot python3-certbot-nginx -y

echo_section_header "Installing MySQL"
sudo apt install mysql-server -y

echo_section_header "Installing Redis"
sudo apt install redis-server -y

echo_section_header "Configuring UFW"
setup_ufu

echo_section_header "Cloning SupportManager"
cd /var/www || exit

git clone git@github.com:TomEasterbrook/support-manager-web.git
git checkout develop


