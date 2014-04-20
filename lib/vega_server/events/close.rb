require 'vega_server/cleanable'
require 'vega_server/outgoing_messages/unexpected_peer_hang_up'

module VegaServer::Events
  class Close
    include VegaServer::Cleanable

    def outgoing_message_class
      VegaServer::OutgoingMessages::UnexpectedPeerHangUp
    end

    def self.handle(websocket, event)
      new(websocket).handle
    end
  end
end
