require 'vega_server/incoming_messages'
require 'vega_server/json'

module VegaServer::Events
  class Message
    def initialize(websocket, event)
      @websocket = websocket
      @event     = event
    end

    def handle
      VegaServer::IncomingMessages::Factory.
        create(@websocket, type, payload).
        handle
    end

    def self.handle(websocket, event)
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
