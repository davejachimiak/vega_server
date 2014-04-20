require 'vega_server/outgoing_messages/offer'

module VegaServer::IncomingMessages
  class Offer
    def initialize(websocket, payload)
      @websocket = websocket
      @offer     = payload[:offer]
      @peer_id   = payload[:peer_id]
      @pool      = VegaServer.connection_pool
      @storage   = VegaServer.storage
    end

    def handle
      VegaServer::OutgoingMessages.send_message(peer_websocket, message)
    end

    private

    def peer_websocket
      @pool[@peer_id]
    end

    def client_id
      @pool.inverted_pool[@websocket]
    end

    def message
      VegaServer::OutgoingMessages::Offer.new(client_id, @offer)
    end
  end
end
