# config/deploy/beta.rb

server 'sweep_deploy', roles: %w{app db web}
set :deploy_to, "/var/www/sweep_bot_beta"
set :tmp_dir, '/home/deploy/tmp'

set :branch, 'sandbox'
set :rails_env, 'beta'

set :linked_files, %w{config/application.yml}