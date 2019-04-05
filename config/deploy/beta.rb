# config/deploy/beta.rb

server 'sweep_beta', roles: %w{app db web}
set :deploy_to, "/var/www/sweep_bot"
set :tmp_dir, '/home/deploy/tmp'

set :branch, 'release-201903'
set :rails_env, 'beta'

set :linked_files, %w{config/application.yml}