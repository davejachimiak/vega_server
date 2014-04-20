require 'vega_server/cleanable'
require 'vega_server/outgoing_messages/peer_hang_up'

module VegaServer::IncomingMessages
  class HangUp
    include VegaServer::Cleanable

    def after_remove_client
      websocket.close
    end

    def outgoing_message_class
      VegaServer::OutgoingMessages::PeerHangUp
    end
  end
end
