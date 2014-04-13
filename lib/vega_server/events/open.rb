module VegaServer::Events
  class Open
    def initialize(websocket, event)
      @websocket       = websocket
      @origin          = event.origin
      @allowed_origins = VegaServer.allowed_origins
    end

    def handle
      if !origin_allowed?
        @websocket.close
        @websocket = nil
      end
    end

    def self.handle(websocket, event)
      event = VegaServer.event_adapter.new(event)
      new(websocket, event).handle
    end

    private

    def origin_allowed?
      return true if @allowed_origins.empty?
      @allowed_origins.include?(@origin)
    end
  end
end
