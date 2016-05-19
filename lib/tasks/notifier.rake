namespace :notifier do
  task :notify, [:message] => :environment  do |t, args|
    if !ENV['SLACK_WEBHOOK_URL'].nil? && !ENV['SLACK_WEBHOOK_URL'].blank?
      p "Sending Slack message"
      DockerHouston::Slack::Message.new(ENV['SLACK_CHANNEL'], args[:message]).notify
    end
    if !ENV['HIPCHAT_TOKEN'].nil? && !ENV['HIPCHAT_TOKEN'].blank?
      p "Sending Hipchat message"
      DockerHouston::Hipchat::Message.new(ENV['HIPCHAT_ROOM'], args[:message]).notify
    end
  end
end