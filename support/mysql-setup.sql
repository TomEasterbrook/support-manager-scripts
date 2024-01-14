CREATE USER 'SupportManager'@'localhost' IDENTIFIED BY '{{DB_PASSWORD}}';
CREATE DATABASE IF NOT EXISTS SupportManager;
GRANT ALL PRIVILEGES ON SupportManager.* TO 'SupportManager'@'localhost';
FLUSH PRIVILEGES;