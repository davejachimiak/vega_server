require 'vega_server/outgoing_messages/client_messageable'
require 'vega_server/outgoing_messages/room_full_error'
require 'vega_server/outgoing_messages/caller_success'
require 'vega_server/outgoing_messages/callee_success'
require 'vega_server/outgoing_messages/unacceptable_peer_type_error'

module VegaServer
  module OutgoingMessages
    def self.send_message(websocket, message)
      websocket.send(message.as_json)
    end
  end
end
