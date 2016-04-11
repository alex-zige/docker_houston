require 'rails/generators/base'
require 'securerandom'

module DockerHouston
  module Generators
    class InstallGenerator < Rails::Generators::Base

      argument :app_name, type: :string, default: Rails.application.class.parent_name.downcase
      argument :app_domain, type: :string, default: "YOUR-APP-HOST-NAME"
      argument :docker_host, type: :string, default: "YOUR-DOCKER_HOST"

      source_root File.expand_path("../../templates", __FILE__)
      desc "Creates a docker configuration template files to your application."

      def copy_dockerfile
        copy_file "Dockerfile.erb", "Dockerfile"
      end

      def copy_docker_compse
        template "docker-compose.yml.erb", "docker-compose.yml"
      end

      def copy_secret
        copy_file "secrets.yml", "config/secrets.yml"
      end

      def copy_unicorn
        copy_file "unicorn.rb", "config/unicorn.rb"
      end

      def copy_capistrano_staging
        template 'staging.rb.erb', "config/deploy/staging.rb"
      end

      def copy_capistrano_deploy
        template 'deploy.rb.erb', "config/deploy.rb"
      end

      def copy_capistrano_file
        copy_file 'Capfile', "Capfile"
      end

      def copy_executable
        copy_file "../../../bin/docker", "bin/docker"
      end

      def rails_4?
        Rails::VERSION::MAJOR == 4
      end

    end
  end
end