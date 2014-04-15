require 'vega_server/incoming_messages'
require 'vega_server/json'

module VegaServer::Events
  class Message
    CALL  = 'call'.freeze
    OFFER = 'offer'.freeze

    def initialize(websocket, event)
      @websocket = websocket
      @event     = event
    end

    def handle
      case type
      when CALL
        VegaServer::IncomingMessages::Call.handle(@websocket, payload)
      when OFFER
        VegaServer::IncomingMessages::Offer.handle(@websocket, payload)
      end
    end

    def self.handle(websocket, event)
      event = VegaServer.event_adapter.new(event)
      new(websocket, event).handle
    end

    private

    def type
      data.type
    end

    def payload
      data.payload
    end

    def data
      @data ||= VegaServer::Json.to_struct(raw_data)
    end

    def raw_data
      @event.data
    end
  end
end
