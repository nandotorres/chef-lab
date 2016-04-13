#
# Cookbook Name:: webapp-linux
# Recipe:: webserver
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Instala Apache e inicia o servico

password_secret = Chef::EncryptedDataBagItem.load_secret(node['webapp-linux']['passwords']['secret_path'])
db_admin_password_data_bag_item = Chef::EncryptedDataBagItem.load('credentials', 'db_admin_password', password_secret)

httpd_service 'customers' do 
  mpm 'prefork'
  action [:create]
end

httpd_config 'customers' do 
  instance 'customers'
  source 'customers.conf.erb'
  notifies :restart, 'httpd_service[customers]'
end

directory node['webapp-linux']['docroot'] do 
  recursive true
end

template "#{node['webapp-linux']['docroot']}/index.php" do
  source 'index.php.erb'
  owner node['webapp-linux']['user']
  group node['webapp-linux']['group']
  mode '0644'
  action :create
  variables({
    :password => db_admin_password_data_bag_item['password']
  })
end

file "#{node['webapp-linux']['docroot']}/info.php" do
  content '<?php phpinfo(); ?>'
  owner node['webapp-linux']['user']
  group node['webapp-linux']['group']
  mode '0644'
  action :create
end

firewall_rule 'http' do 
  port 80
  protocol :tcp
  action :create
end

httpd_module 'php5' do
  instance 'customers'
end

package 'php5-mysql' do
  action :install
  notifies :restart, 'httpd_service[customers]'
end

