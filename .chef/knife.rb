raise "You must set the ORGNAME environment variable to your trainer's organization on Opscode Hosted Chef." if ENV['ORGNAME'].nil?
current_dir = File.dirname(__FILE__)
user = ENV['OPSCODE_USER'] || ENV['USER']
log_level                :info
log_location             STDOUT
node_name                user
client_key               "#{ENV['HOME']}/.chef/#{user}.pem"
validation_client_name   "#{ENV['ORGNAME']}-validator"
validation_key           "#{ENV['HOME']}/.chef/#{ENV['ORGNAME']}-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/#{ENV['ORGNAME']}"
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]

knife[:distro] = "student"

# AWS
knife[:aws_access_key_id]       = ENV['AWS_ACCESS_KEY_ID']
knife[:aws_secret_access_key]   = ENV['AWS_SECRET_ACCESS_KEY']
knife[:aws_ssh_key_id]          = ENV['AWS_SSH_KEY']

# Rackspace Cloud
knife[:rackspace_api_username]  = ENV['RACKSPACE_USERNAME']
knife[:rackspace_api_key]       = ENV['RACKSPACE_API_KEY']
