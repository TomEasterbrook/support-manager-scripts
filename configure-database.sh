read -p 'Please enter a MySql Database Password: ' dbPassword
cp support/mysql-setup.sql mysql-setup.sql
sed -i "s/{{DB_PASSWORD}}/$dbPassword/g" mysql-setup.sql
sudo mysql < mysql-setup.sql
rm mysql-setup.sql
echo "Database setup complete"