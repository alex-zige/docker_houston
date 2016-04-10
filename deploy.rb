require 'docker_houston/capistrano'

set :app_name, ""
set :working_dir, "/home/deploy/dockerised_apps/#{fetch(:app_name)}"
set :docker_repository, ""
