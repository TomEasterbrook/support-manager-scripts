function update_repo() {
    echo_section_header "Updating repository"
    sudo add-apt-repository ppa:ondrej/php -y
    sudo apt update

}

function install_php() {
     if ! [ -f /etc/php/8.3/fpm/php.ini ]; then
            echo_section_header "Installing PHP"
            sudo apt install php7.4 php7.4-fpm php7.4-mysql php7.4-redis php7.4-mbstring php7.4-xml php7.4-curl php7.4-zip php7.4-gd php7.4-bcmath php7.4-intl php7.4-imagick -y
            else
            echo_section_header "PHP already installed"
        fi
        if ! [ -f /usr/local/bin/composer ]; then
            echo_section_header "Installing Composer"
            curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
            else
            echo_section_header "Composer already installed"
        fi

}

function install_npm() {
        if ! [ -f /usr/bin/node ]; then
            echo_section_header "Installing NodeJS"
            sudo apt install nodejs npm -y
            npm install -g n
            sudo n stable
            else
            echo_section_header "NodeJS already installed"
        fi
}
function install_supervisor() {
    if ! [ `command -v "supervisorctl"` ]; then
        echo_section_header "Installing Supervisor"
        sudo apt install supervisor -y
        else
        echo_section_header "Supervisor already installed"
    fi
}
function install_webserver() {
     if ! [ `command -v "nginx"` ]; then
          echo_section_header "Installing Nginx"
          sudo apt install nginx -y
          else
          echo_section_header "Nginx already installed"

      fi

      if ! [ `command -v "certbot"` ]; then
          echo_section_header "Installing Certbot"
          sudo apt install certbot python3-certbot-nginx -y
          else
          echo_section_header "Certbot already installed"
      fi

}

function install_databases() {
      if ! [ `command -v "mysql"` ]; then
          echo_section_header "Installing MySQL"
          sudo apt install mysql-server -y
          else
          echo_section_header "MySQL already installed"
      fi

      if ! [ `command -v "redis-server"` ]; then
          echo_section_header "Installing Redis"
          sudo apt install redis-server -y
          else
          echo_section_header "Redis already installed"
      fi

}

function install_packages() {
   #Disable interactive prompts
   sed -i "s/#\$nrconf{restart} = 'i';/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf
    update_repo
    install_php
    install_npm
    install_supervisor
    install_webserver
    install_databases
}
install_packages
