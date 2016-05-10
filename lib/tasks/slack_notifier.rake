namespace :slack_notifier do
  task :notify => :environment  do
     DockerHouston::Slack::Message.new("test","test-room").notify
  end
end