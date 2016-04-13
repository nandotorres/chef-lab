#
# Cookbook Name:: webapp-linux
# Recipe:: webserver
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Instala Apache e inicia o servico

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

file "#{node['webapp-linux']['docroot']}/index.php" do
  content '<h1>Temporary page</h1>'
  owner 'web-admin'
  group 'web-admin'
  mode '0644'
  action :create
end

firewall_rule 'http' do 
  port 80
  protocol :tcp
  action :create
end
