module DockerHouston
  module Slack
    class Message
      def initialize(channel, text)
        @uri = URI.parse(ENV['SLACK_WEBHOOK_URL'])
        @channel = channel
        @channel = '#' + @channel unless @channel.include? '#'
        @text = text
      end

      def notify
        response = Net::HTTP.post_form(@uri, {'payload' => {
                                               "channel" => @channel,
                                               "text" => @text,
                                               "username" => "Docker Houston",
                                               "icon_emoji" => ":rocket:"
                                           }.to_json }
        )
      end
    end
  end
end