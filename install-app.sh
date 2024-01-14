
function configure_git_ssh_keys() {
    echo "github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
          github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=
          github.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=" >> ~/.ssh/known_hosts
}
function clone_repo() {
  echo_section_header "Cloning SupportManager"
  if [ -d /var/www/"$domain" ]; then
      sudo rm -r /var/www/"$domain"
  fi
  cd /var/www || exit
  git clone git@github.com:TomEasterbrook/support-manager-web.git "$domain"
  cd /var/www/"$domain"|| exit
    git checkout develop
}
function restore_cache() {
  if [ -d ~/cache ]; then
     echo_section_header "Restoring Composer dependencies from cache - this may take a while"
     cp -r ~/cache/vendor /var/www/"$domain"/vendor
     echo_section_header "Restoring NPM from cache - this may take a while"
     cp -r ~/cache/node_modules /var/www/"$domain"/node_modules
     echo "Cache restored"
  fi
}
function create_cache() {
  if ! [ -d ~/cache ]; then
   mkdir -p ~/cache
   cp -r /var/www/"$domain"/vendor ~/cache/vendor
   cp -r /var/www/"$domain"/node_modules ~/cache/node_modules
   echo "Cache of dependencies created"

  fi
}
function install_dependencies() {
  export COMPOSER_ALLOW_SUPERUSER=1
  composer install --no-scripts
  npm config set "@fortawesome:registry" https://npm.fontawesome.com/
  npm config set '//npm.fontawesome.com/:_authToken' "$fontAwesomeToken"
  npm install
  npm run build
  composer dump-autoload -o
}
function make_file_changes() {
  cp .env.example .env
  php artisan key:generate
  chmod -R 777 storage bootstrap/cache
  cd storage/ || exit
  mkdir -p framework/{sessions,views,cache}
  chmod -R 775 framework
}
function install_app() {
  echo_section_header "Installing SupportManager"
  configure_git_ssh_keys
  clone_repo
  restore_cache
  install_dependencies
  make_file_changes
  create_cache
  cd ~ || exit
}
install_app