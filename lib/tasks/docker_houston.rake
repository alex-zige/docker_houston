set(:branch, (ENV['tag'] || ENV['branch'] || ask(:branch, `git describe --abbrev=0 --tags`.strip)))

begin
  fetch(:repository)
  fetch(:application)
rescue IndexError => e
  puts "#{e.message} (ensure :application and :repository are set in deploy.rb)"
end

set :app_with_stage, ->{"#{fetch(:application)}_#{fetch(:stage)}"}
set :repo_url, ->{ fetch(:repository) } unless fetch(:repo_url)

set :release_dir, ->{Pathname.new("/home/deploy/dockerised_apps/#{fetch(:app_with_stage)}/current")}
set :shared_dir, ->{Pathname.new("/home/deploy/dockerised_apps/#{fetch(:app_with_stage)}/shared")}
set :app_dir, ->{fetch(:release_dir).to_s.chomp('/current')}

# Override the release_path to be current_path as we
# have no notion of release folders

def exec_on_remote(command, message="Executing command on remote...", container_id='web')
  on roles :app do |server|
    ssh_cmd = "ssh -A -t #{server.user}@#{server.hostname}"
    puts message

    if docker?
      exec "#{ssh_cmd} 'cd #{fetch(:release_dir)} && sudo docker-compose -p #{fetch(:app_with_stage)} run web #{command}'"
    else
      exec "#{ssh_cmd} 'cd #{fetch(:deploy_to)}/current && RAILS_ENV=#{fetch(:stage)} #{command}'"
    end
  end
end

def docker?
  !!fetch(:docker)
end

desc 'Run a rails console on remote'
task :console do
  exec_on_remote("bundle exec rails c", "Running console on remote...")
end

desc 'Run a bash terminal on remote'
task :bash do
  exec_on_remote("bash", "Running bash terminal on remote...")
end

namespace :docker do

  namespace :copy do

    desc 'Copy files and directories from shared to current'
    task :shared do
      invoke 'docker:copy:linked_files'
      invoke 'docker:copy:linked_dirs'
    end

    desc 'Symlink linked directories'
    task :linked_dirs do
      next unless any? :linked_dirs
      on release_roles :all do

        fetch(:linked_dirs).each do |dir|
          target = fetch(:release_dir).join(dir)
          source = fetch(:shared_dir).join(dir)
          # Skip the directory if the target is a symlink or the source does not exists
          next if (test("[ -L #{target} ]") || !test("[ -d #{source} ]"))
          if test "[ -d #{target} ]"
            execute :rm, '-rf', target
          end
          execute :cp, source, target
        end
      end
    end

    desc 'Symlink linked files'
    task :linked_files do
      next unless any? :linked_files
      on release_roles :all do

        fetch(:linked_files).each do |file|
          target = fetch(:release_dir).join(file)
          source = fetch(:shared_dir).join(file)
          next if (test("[ -L #{target} ]") || !test("[ -f #{source} ]"))
          if test "[ -f #{target} ]"
            execute :rm, target
          end
          execute :cp, source, target
        end
      end
    end

  end

  namespace :nginx do

    desc "start up nginx reverse-proxy webserver container on VPS"
    task :start do
      on roles :app do
        within "/home/deploy/dockerised_apps/nginx-proxy" do
          start
        end
      end
    end

    desc "shut down nginx reverse-proxy webserver container on VPS"
    task :stop do
      on roles :app do
        within "/home/deploy/dockerised_apps/nginx-proxy" do
          stop
        end
      end
    end
  end

  desc "deploy a git tag to a docker container"
  task :deploy do
    on roles :app do
      invoke 'docker:setup_dir_struct'
      invoke 'docker:git_clone'
      invoke 'docker:git_checkout'
      invoke 'docker:copy:shared'
      invoke 'docker:build_container'
      invoke 'docker:precompile_assets'
      invoke 'docker:stop'
      invoke 'docker:start'
      invoke 'docker:notify_rollbar' if Gem.loaded_specs.has_key?('rollbar')
    end
  end

  task :notify_rollbar do
    # if we are in the CI environment set username to 'Codeship ( ruby_fu_ninja )'
    whoami = ENV['CI'] ? "Codeship" : `whoami`.chomp
    exec_on_remote(%{bash -c "WHOAMI=#{whoami} bundle exec rake docker_captain:notify_rollbar"})
  end

  desc "setup necessary directory structure for deployment"
  task :setup_dir_struct do
    on roles :app do
      app_d = fetch(:app_dir)
      log_d = "/home/deploy/log/#{fetch(:app_with_stage)}"

      [
        "#{app_d}/current",
        "#{app_d}/shared",
        log_d
      ].each do |dir|
        if !test "[ -d #{dir} ]"
          execute :mkdir, "-p #{dir}"
        end
      end

    end
  end

  desc "git clone"
  task :git_clone do
    on roles :app do
      within fetch(:app_dir) do
        if !test "[ -d #{fetch(:release_dir)}/.git ]"
          execute "git clone #{fetch(:repo_url)} #{fetch(:release_dir)}"
        end
      end

      docker_db = "#{fetch(:release_dir)}/config/database.yml.docker"
      if test "[ -f #{docker_db} ]"
        execute :cp, "#{docker_db} #{docker_db.chomp('.docker')}"
      end
    end
  end

  desc "git checkout"
  task :git_checkout do
    on roles :app do
      within fetch(:release_dir) do
        execute *%w[ git fetch --tags ]
        execute :echo, "git tags available..."
        execute *%w[ git tag --list | sort -t. -k 1,1n -k 2,2n -k 3,3n | xargs]
        execute :git, "checkout #{fetch(:branch)} -f"
      end
    end
  end

  desc "build container"
  task :build_container do
    on roles :app do
      within fetch(:release_dir) do
        execute :sudo, "docker-compose -p #{fetch(:app_with_stage)} build web"
        execute :echo, "bundling project..."
        execute :sudo, "docker-compose -p #{fetch(:app_with_stage)} run web bundle --without development test"
      end
    end
  end

  desc "precompile assets"
  task :precompile_assets do
    on roles :app do
      within fetch(:release_dir) do
        execute :echo, "precompiling assets..."
        execute :sudo, "docker-compose  -p #{fetch(:app_with_stage)} run web bundle exec rake assets:precompile"
      end
    end
  end

  desc "start service"
  task :start do
    on roles :app do
      within fetch(:release_dir) do
        execute :sudo, "docker-compose -p #{fetch(:app_with_stage)} up -d"
      end
    end
  end

  desc "stop service"
  task :stop do
    on roles :app do
      within fetch(:release_dir) do
        execute :sudo, "docker-compose -p #{fetch(:app_with_stage)} kill" # kill the running containers
        execute :sudo, "docker-compose -p #{fetch(:app_with_stage)} rm --force"
      end
    end
  end

  desc 'Run a bash console attached to the running docker application'
  task :bash do
    invoke 'bash'
  end

  desc 'Run a console attached to the running docker application'
  task :console do
    invoke 'console'
  end

  namespace :db do
    task :copy_to_local do
      puts "Executing pg_dump --host=$POSTGRESQL_PORT_5432_TCP_ADDR --port=$POSTGRESQL_PORT_5432_TCP_PORT --username=$POSTGRES_USER #{fetch(:app_with_stage)} > $PGDATA/staging.sql"
      exec_on_remote("pg_dump --host=$POSTGRESQL_PORT_5432_TCP_ADDR --port=$POSTGRESQL_PORT_5432_TCP_PORT --username=$POSTGRES_USER #{fetch(:app_with_stage)} > $PGDATA/staging.sql", 'Generating pg dump', 'postgresql')
      download!(File.join(fetch(:release_dir), 'postgres-data', 'data', 'staging.sql'))
    end
  end

  namespace :logs do
    task :tail do
      exec_on_remote("tail -f log/*.log", 'Connecting to docker host...')
    end
  end
end
