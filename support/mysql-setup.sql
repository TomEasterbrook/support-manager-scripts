UPDATE mysql.user SET Password=PASSWORD('{{DB_ROOT_PASSWORD}}') WHERE User='root';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';
CREATE USER '{{DB_USERNAME}}'@'localhost' IDENTIFIED BY '{{DB_PASSWORD}}';
CREATE DATABASE IF NOT EXISTS '{{DB_DATABASE}}';
GRANT ALL PRIVILEGES ON {{DB_DATABASE}}.* TO 'SupportManager'@'localhost';
FLUSH PRIVILEGES;