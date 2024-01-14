read -p 'Please enter a MySql root password: ' rootPassword
read -p 'Please enter a MySql Database Username: ' dbUsername
read -p 'Please enter a MySql Database Password: ' dbPassword
read -p 'Please enter a MySql Database Name: ' dbName

eche_section_header "Configuring MySql"
cp support/mysql-setup.sql mysql-setup.sql
sed -i "s/{{DB_ROOT_PASSWORD}}/$rootPassword/g" mysql-setup.sql
sed -i "s/{{DB_DATABASE}}/$dbName/g" mysql-setup.sql
sed -i "s/{{DB_USERNAME}}/$dbUsername/g" mysql-setup.sql
sed -i "s/{{DB_PASSWORD}}/$dbPassword/g" mysql-setup.sql
sudo mysql < mysql-setup.sql
rm mysql-setup.sql
echo "Database setup complete"

echo "
DB_ROOT_PASSWORD=$rootPassword \n
DB_USERNAME=$dbUsername \n
DB_PASSWORD=$dbPassword \n
DB_DATABASE=$dbName \n" >> DBDetails.txt

echo "Database details saved to DBDetails.txt as plain text. Please delete this file when you have finished with it.
"