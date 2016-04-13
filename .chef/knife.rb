# See https://docs.getchef.com/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "nandotorres"
client_key               "#{current_dir}/nandotorres.pem"
validation_client_name   "contoso-validator"
validation_key           "#{current_dir}/contoso-validator.pem"
chef_server_url          "https://chef-server.c40nwaodf5qe5hlcrlmrrvhejg.nx.internal.cloudapp.net/organizations/contoso"
cookbook_path            ["#{current_dir}/../cookbooks"]
