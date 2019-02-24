# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "playsweep"
set :repo_url, "git@github.com:ryanwaits/#{fetch :application}.git"
set :forward_agent, true
set :port, '22'  
set :migration_role, :app
set :assets_roles, [:web, :app]

set :rvm_ruby_version, 'ruby-2.4.1@default'      # Defaults to: 'default'
set :rvm_map_bins, %w{gem rake ruby rails bundle}

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads', 'node_modules'
#append :linked_files, 'config/database.yml'

set :keep_releases, 8
set :passenger_restart_with_touch, true

# Dafault to QA ENV stageless deploy
set :stage, :staging
# after "deploy", "nc:finished"
