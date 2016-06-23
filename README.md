# DockerHouston

[![Gem Version](https://badge.fury.io/rb/docker_houston.svg)](https://badge.fury.io/rb/docker_houston)

DockerHouston is a utility for deploying rails app into a docker environments.

It builds on the top of Capistrano for different deployment to a docker host.

DockerHouston comes with a generator to copy and templates all necessary config files and to the target rails project.

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


### Prerequisite

Add `unicorn` to gemfile and ensure the `therubyracer` is enabled.

```ruby
gem 'therubyracer', platforms: :ruby

gem 'unicorn'

```

### Install

```ruby
rails g docker_houston:install APP_NAME APP_DOMAIN DOCKER_HOST

```

APP_NAME: the app name for your project.

APP_DOMAIN: the virtual url for the app.

DOCKER_HOST: the remote host for docker instance.


###Make `bin/docker` executable

```
chmod +x bin/docker

```

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
invoke 'docker:cleanup_containers'
invoke 'docker:cleanup_images'
invoke 'docker:notify'

```
* Deploy a new version to the current folder.
* Build the container for it.
* Stop the current running containers if existed.
* Start new container for the project.
* Clean up exited containers
* Clean up unlinked images
* Notifying to Team channel


### Console
You can also run console command insdie the rails app within the docker container.

```ruby
cap staging docker:console

```

### Notifying
To integrate with your IM chat, [Slack](https://slack.com) or [HipChat](https://www.hipchat.com)
Provide the following ENV variables to enable that service:

####Slack
```
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/TXXXXX/BXXXXX/XXXXXXXXXX
SLACK_CHANNEL=general

```

####HipChat
```
HIPCHAT_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
HIPCHAT_ROOM=Water Cooler

```

The deploy message reads: "New version of #{fetch(:app_name)} has been deployed at #{fetch(:app_domain)}."

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/alex-zige/docker_houston. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
