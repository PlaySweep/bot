# config/deploy/production.rb

server "sweep", roles: %w{app db web }
set :deploy_to, "/var/www/#{fetch :application}"
after "deploy:restart"

set :branch, 'sandbox'
set :rails_env, 'staging'

# role :resque_worker, "sweep"
# role :resque_scheduler, "sweep"

# set :resque_environment_task, true
# set :workers, { "*" => 4 }