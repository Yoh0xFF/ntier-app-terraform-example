create database ntier default character set UTF8;
create user admin identified by '***';
grant all privileges on ntier.* TO 'admin'@'%';
