require 'rails/generators/base'
require 'securerandom'

module DockerHouston
  module Generators
    class InstallGenerator < Rails::Generators::Base

      argument :app_name, type: :string, default: Rails.application.class.parent_name.downcase

      source_root File.expand_path("../../templates", __FILE__)
      desc "Creates a docker configuration template files to your application."

      def copy_dockerfile
        template "Dockerfile.erb", "Dockerfile"
      end

      def copy_docker_compse
        template "docker-compose.yml.erb", "docker-compose.yml"
      end

      def copy_unicorn
        copy_file "unicorn.rb", "config/unicorn.rb"
      end

      def rails_4?
        Rails::VERSION::MAJOR == 4
      end
    end
  end
end