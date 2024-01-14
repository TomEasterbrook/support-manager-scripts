#!/usr/bin/bash

function echo_section_header() {
    echo "------------------------------------------------------------"
    echo "$1..."
    echo "------------------------------------------------------------"
}


function setup_ufu() {
     echo_section_header "Configuring UFW"
    sudo ufw allow 'Nginx Full'
    sudo ufw allow 'OpenSSH'
    sudo ufw delete allow 'Nginx HTTP'
    sudo ufw --force enable

}
function get_data() {
    echo 'First we need to get some information about your environment'
    read -p 'What is your domain name? (e.g. example.com): ' domain
    read -p 'Please enter a FontAwesome Pro token: ' fontAwesomeToken
    export domain
    export fontAwesomeToken

}


function configure_nginx() {
    echo_section_header "Configuring Web Server"
    cp ~/support-manager-scripts/support/nginx.conf /etc/nginx/sites-available/"$domain".conf
    sed -i "s/{{DOMAIN}}/$domain/g" /etc/nginx/sites-available/"$domain".conf
    ln -s /etc/nginx/sites-available/"$domain".conf /etc/nginx/sites-enabled/
    echo_section_header "Configuring SSL"
    echo "Please follow the prompts to configure SSL. Press enter to continue"
    sudo certbot --nginx -d "$domain"
    sudo systemctl restart nginx
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
setup_ufu
chmod +x install-app.sh
./install-app.sh
configure_nginx