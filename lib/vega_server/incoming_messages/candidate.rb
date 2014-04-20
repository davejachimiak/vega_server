require 'vega_server/outgoing_messages/candidate'

module VegaServer::IncomingMessages
  class Candidate
    def initialize(websocket, payload)
      @websocket = websocket
      @candidate = payload[:candidate]
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
      VegaServer::OutgoingMessages::Candidate.new(client_id, @candidate)
    end
  end
end
