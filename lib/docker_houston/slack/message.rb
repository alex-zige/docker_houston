module DockerHouston
  module Slack
    class Message
      def initialize(channel, text)
        @uri = URI("https://slack.com/api/chat.postMessage?token=#{ENV['SLACK_TOKEN']}")
        @channel = @channel
        @text = text
      end

      def notify
        response = Net::HTTP.post_form(@uri,
          channel: @channel,
          text: @text
       )
      end
    end
  end
end