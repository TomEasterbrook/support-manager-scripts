function setup_ufw() {
  echo_section_header "Configuring UFW"
  sudo ufw allow 'Nginx Full'
  sudo ufw allow 'OpenSSH'
  sudo ufw delete allow 'Nginx HTTP'
  sudo ufw --force enable

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
setup_ufw
configure_nginx