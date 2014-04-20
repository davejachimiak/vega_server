require 'vega_server/outgoing_messages/answer'

module VegaServer::IncomingMessages
  class Answer
    def initialize(websocket, payload)
      @websocket = websocket
      @answer    = payload[:answer]
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
      VegaServer::OutgoingMessages::Answer.new(client_id, @answer)
    end
  end
end
