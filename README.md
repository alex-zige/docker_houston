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


##Custom Command Cap Command

```ruby
cap -T

```
Check all the docker command that is avaiable to you.


### Deployment

```ruby
cap staging docker:lift_off

```

This will we do the following:

```ruby
      invoke 'deploy'
      invoke 'docker:setup_db'
      invoke 'docker:build_container'
      invoke 'docker:stop'
      invoke 'docker:start'
      invoke 'docker:notify'
```
* Deploy a new version to the current folder.
* Build the container for it.
* Stop the current running containers if existed.
* Start new container for the project.
* Notifying to Team channel (TODO://)


### Console
You can also run console command insdie the rails app within the docker container.

```ruby
cap staging docker:console

```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/docker_houston. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

