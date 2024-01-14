CREATE USER 'SupportManager'@'localhost' IDENTIFIED BY '{{$Password}}';
CREATE DATABASE IF NOT EXISTS SupportManager;
GRANT ALL PRIVILEGES ON SupportManager.* TO 'SupportManager'@'localhost';
FLUSH PRIVILEGES;