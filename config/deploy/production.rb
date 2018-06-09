# config/deploy/production.rb

server "sweep", roles: %w{app db web }
set :deploy_to, "/var/www/#{fetch :application}"
after "deploy:restart", "resque:restart"

set :branch, 'master'
set :rails_env, 'production'

# role :resque_worker, "sweep"
# role :resque_scheduler, "sweep"

# set :resque_environment_task, true
# set :workers, { "*" => 4 }