module VegaServer::Events
  module Handleable
    attr_reader :websocket, :event

    def initialize(websocket, event)
      @websocket = websocket
      @event     = event
    end

    def handle
      raise NotImplementedError
    end

    def self.included(base)
      base.class_eval do
        def self.handle(websocket, event)
          event = VegaServer.event_adapter.new(event)
          new(websocket, event).handle
        end
      end
    end
  end
end
