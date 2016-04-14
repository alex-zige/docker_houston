# DockerHouston

DockerHouston is a utiilty for deploying rails app into a docker environments.

It builds on the top of Capistrano for differnt deployment to a docker host.

docker_houston comes with a generator to copy and templates all necessary config files and to the target rails project.


###Prerequisite
Make sure you have access to the ``docker_host`` with the user as ``deploy``.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'docker_houston'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install docker_houston

## Getting Started

### Install

```ruby
rails g docker_houston:install APP_NAME APP_DOMAIN DOCKER_HOST
```

APP_NAME: the app name for your project.

APP_DOMAIN: the virtual url for the app.

DOCKER_HOST: the remote host for docker instance.

## Deployment

```ruby
cap staging docker:lift_off

```

Run a docker deployment on the docker host.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/docker_houston. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

