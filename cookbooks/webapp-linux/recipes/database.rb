#
# Cookbook Name:: webapp-linux
# Recipe:: database
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Configure mysql2 ruby gem

mysql2_chef_gem 'default' do
  action :install
end

# Configure mysql client
mysql_client 'default' do
  action :create
end

# Load secrets
password_secret = Chef::EncryptedDataBagItem.load_secret(node['webapp-linux']['passwords']['secret_path'])
root_password_data_bag_item = Chef::EncryptedDataBagItem.load('credentials', 'mysql_root_password', password_secret)
db_admin_password_data_bag_item = Chef::EncryptedDataBagItem.load('credentials', 'db_admin_password', password_secret)

# mysql connection variables
mysql_host = node['webapp-linux']['database']['host']
mysql_instance = node['webapp-linux']['database']['instance']
mysql_user = node['webapp-linux']['database']['username']
mysql_db = node['webapp-linux']['database']['dbname']
mysql_socket = "/var/run/mysql-#{mysql_instance}/mysqld.sock"

mysql_service mysql_instance do
  initial_root_password root_password_data_bag_item['password']
  action [:create, :start]
end

mysql_database node['webapp-linux']['database']['dbname'] do 
  connection(
    :host => mysql_host,
    :username => mysql_user,
    :password => root_password_data_bag_item['password'],
    :socket   => mysql_socket
  )
  action :create
end

mysql_database_user node['webapp-linux']['database']['app']['username'] do 
  connection(
    :host => mysql_host,
    :username => mysql_user,
    :password => root_password_data_bag_item['password'],
    :socket   => mysql_socket
  )

  password db_admin_password_data_bag_item['password']
  database_name mysql_db
  host mysql_host
  privileges [:select,:update,:insert,:delete]
  action :grant 
end

cookbook_file node['webapp-linux']['database']['seed_file'] do
  source 'create-database.sql'
  owner 'root'
  group 'root'
  mode '0600'
  action :create
end

execute 'initialize database' do 
  command "mysql -h #{mysql_host} -u #{mysql_user} -p#{root_password_data_bag_item['password']} -D #{mysql_db} --socket=#{mysql_socket} < #{node['webapp-linux']['database']['seed_file']}"
  not_if "mysql -h #{mysql_host} -u #{mysql_user} -p#{root_password_data_bag_item['password']} -D #{mysql_db} --socket=#{mysql_socket} -e 'describe customers;'"
  action :run
end












