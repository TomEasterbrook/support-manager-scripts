#!/usr/bin/bash

function echo_section_header() {
    echo "------------------------------------------------------------"
    echo "$1..."
    echo "------------------------------------------------------------"
}



function get_data() {
    echo 'First we need to get some information about your environment'
    read -p 'What is your domain name? (e.g. example.com): ' domain
    read -p 'Please enter a FontAwesome Pro token: ' fontAwesomeToken
    read -p 'Install MySQL? (y/n): ' mysql
    read -p 'Install Redis? (y/n): ' redis

    export mysql
    export domain
    export fontAwesomeToken

}

function configure_supervisor() {
    echo_section_header "Configuring Supervisor"
    sudo cp ~/support-manager-scripts/support/supervisor.conf /etc/supervisor/conf.d/"$domain".conf
    sudo sed -i "s/{{DOMAIN}}/$domain/g" /etc/supervisor/conf.d/"$domain".conf
    sudo supervisorctl reread
    sudo supervisorctl update
    sudo supervisorctl start "$domain"
}

export -f echo_section_header

echo_section_header "Welcome to the SupportManager server setup script"
echo "Welcome to the SupportManager the server setup script
This script will install all the required dependencies for the SupportManager to run"

read -p "Press enter to continue"

get_data

sudo chmod +x install-packages.sh
./install-packages.sh

chmod +x install-app.sh
./install-app.sh

sudo chmod +x configure-webserver.sh
./configure-webserver.sh

if  [ "$mysql" = "y" ]; then
  sudo chmod +x configure-database.sh
  ./configure-database.sh
fi


