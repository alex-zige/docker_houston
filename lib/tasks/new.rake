namespace :aaa do
  task :bbb do
    invoke "deploy:print_config_variables" if fetch(:print_config_variables, false)
    invoke "deploy:check"
    invoke "deploy:set_previous_revision"
  end
end