require 'vega_server/outgoing_messages/offer'

module VegaServer::IncomingMessages
  class Offer
    def initialize(websocket, payload)
      @websocket = websocket
      @offer     = payload[:offer]
      @pool      = VegaServer.connection_pool
      @storage   = VegaServer.storage
    end

    def handle
      room_peer_websockets.each do |websocket|
        VegaServer::OutgoingMessages.send_message(websocket, message)
      end
    end

    def self.handle(websocket, payload)
      new(websocket, payload).handle
    end

    private

    def room_peer_websockets
      room = @storage.client_room(client_id)

      client_ids = room.reject do |key|
        key == client_id
      end

      client_ids.map { |id| @pool[id] }
    end

    def client_id
      @pool.inverted_pool[@websocket]
    end

    def message
      VegaServer::OutgoingMessages::Offer.new(client_id, @offer)
    end
  end
end
