require 'vega_server/meddleable'

module VegaServer::IncomingMessages
  module Relayable
    include VegaServer::Meddleable

    attr_reader :payload

    def initialize(websocket, payload)
      @websocket = websocket
      @payload   = payload
      @peer_id   = @payload[:peer_id]
    end

    def handle
      VegaServer::OutgoingMessages.send_message(peer_websocket, message)
    end

    private

    def peer_websocket
      pool[@peer_id]
    end

    def client_id
      pool.inverted_pool[@websocket]
    end
    
    def message
      outgoing_message_class.new(client_id, read_relayable)
    end

    def outgoing_message_class
      raise NotImplementedError
    end

    def read_relayable
      raise NotImplementedError
    end
  end
end
