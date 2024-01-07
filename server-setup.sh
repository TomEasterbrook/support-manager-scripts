#!/usr/bin/bash

function echo_section_header() {
    echo "------------------------------------------------------------"
    echo "$1..."
    echo "------------------------------------------------------------"
    sleep 3
}


function setup_ufu() {
     echo_section_header "Configuring UFW"
    sudo ufw allow 'Nginx Full'
    sudo ufw allow 'OpenSSH'
    sudo ufw delete allow 'Nginx HTTP'
    sudo ufw --force enable

}
function configure_git() {
    echo "github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
          github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=
          github.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=" >> ~/.ssh/known_hosts
}
function get_data() {
    echo 'First we need to get some information about your environment'
    read -p 'What is your domain name? (e.g. example.com): ' domain
    read -p 'Please enter a FontAwesome Pro token: ' fontAwesomeToken
    export domain
    export fontAwesomeToken

}
function install_packages() {
   #Disable interactive prompts
   sed -i "s/#\$nrconf{restart} = 'i';/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf

    echo_section_header "Updating system"
    sudo add-apt-repository ppa:ondrej/php -y
    sudo apt update

    echo_section_header "Installing PHP"
    sudo apt install php8.3 php8.3-cli php8.3-{bz2,curl,fpm,mbstring,mysql,redis,intl,xml,zip} -y

    echo_section_header "Installing Composer"
    if ! [ -f /usr/local/bin/composer ]; then
        curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
    fi

    echo_section_header "Installing NodeJS"
    if ! [ -f /usr/bin/node ]; then
        sudo apt install nodejs npm -y
        npm install -g n
        sudo n stable
    fi

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
}
function clone_repo() {
  echo_section_header "Cloning SupportManager"
  if [ -d /var/www/"$domain" ]; then
      sudo rm -r /var/www/"$domain"
  fi
  cd /var/www || exit
  git clone git@github.com:TomEasterbrook/support-manager-web.git "$domain"
}
function install_app() {
      cd /var/www/"$domain"|| exit
      git checkout develop
      if [ -d ~/cache ]; then
          cp -r ~/cache/vendor /var/www/"$domain"/vendor
          cp -r ~/cache/node_modules /var/www/"$domain"/node_modules
          fi
        composer install --no-scripts
        npm config set "@fortawesome:registry" https://npm.fontawesome.com/
        npm config set '//npm.fontawesome.com/:_authToken' "$fontAwesomeToken"
        npm install
        npm run build
        mkdir -p ~/cache
        cp -r /var/www/"$domain"/vendor ~/cache/vendor
        cp -r /var/www/"$domain"/node_modules ~/cache/node_modules
        echo "Cache of dependencies created"



      composer dump-autoload -o
      cd ~ || exit
}
cd ~ || exit
echo_section_header "Welcome to the SupportManager server setup script"
echo "Welcome to the SupportManager the server setup script
This script will install all the required dependencies for the SupportManager to run"

read -p "Press enter to continue"

get_data
install_packages
configure_git

setup_ufu
clone_repo
install_app