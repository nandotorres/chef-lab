default['webapp-linux']['user'] = 'web-admin'
default['webapp-linux']['group'] = 'web-admin'
default['webapp-linux']['docroot'] = '/var/www/customers/public_html'

default['firewall']['allow_ssh'] = true

default['webapp-linux']['passwords']['secret_path'] = '/etc/chef/encrypted_data_bag_secret'

default['webapp-linux']['database']['instance'] = 'default'
default['webapp-linux']['database']['dbname'] = 'products'
default['webapp-linux']['database']['username'] = 'root'
default['webapp-linux']['database']['host'] = 'localhost'

default['webapp-linux']['database']['app']['username'] = 'db_admin'
default['webapp-linux']['database']['seed_file'] = '/tmp/create-database.sql'
