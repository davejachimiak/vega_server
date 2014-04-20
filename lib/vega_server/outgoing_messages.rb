require 'vega_server/outgoing_messages/client_messageable'
require 'vega_server/outgoing_messages/room_full'
require 'vega_server/outgoing_messages/call_accepted'

module VegaServer
  module OutgoingMessages
    def self.send_message(websocket, message)
      websocket.send(message.as_json)
    end
  end
end
