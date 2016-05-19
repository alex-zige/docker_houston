module DockerHouston
  module Hipchat
    class Message
      def initialize(room, text)
        @uri = URI("http://api.hipchat.com/v1/rooms/message")
        @room = room
        @text = text
        @token = ENV['HIPCHAT_TOKEN']
      end

      def notify
        response = Net::HTTP.post_form(@uri, {
                                              "auth_token" => @token,
                                              "room_id" => @room,
                                              "message" => @text,
                                              "from" => "Docker Houston",
                                              "message_format" => "text"
                                          })
      end
    end
  end
end