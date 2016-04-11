# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'docker_houston/version'

Gem::Specification.new do |spec|
  spec.name          = "docker_houston"
  spec.version       = DockerHouston::VERSION
  spec.authors       = ["alex-zige"]
  spec.email         = ["alex.zige@gmail.com"]

  spec.summary       = "Misson Control for docker builds."
  spec.description   = "Utilities for deploy docker builds."
  spec.homepage      = "http://www.google.com"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib","bin","tasks"]
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "rails"
  spec.add_dependency 'capistrano', '~> 3.1'
end
