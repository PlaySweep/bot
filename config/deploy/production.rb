# config/deploy/production.rb

server 'sweep_deploy', roles: %w{app db web}
set :deploy_to, "/var/www/sweep_bot"
set :tmp_dir, '/home/deploy/tmp'

set :branch, 'master'
set :rails_env, 'production'

set :linked_files, %w{config/application.yml}