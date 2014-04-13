module VegaServer::Events
  class Open
    def initialize(websocket, event, origin)
      @websocket       = websocket
      @origin          = origin
      @allowed_origins = VegaServer.allowed_origins
    end

    def handle
      if !origin_allowed?
        @websocket.close
        @websocket = nil
      end
    end

    def self.handle(websocket, event, origin)
      new(websocket, event, origin).handle
    end

    private

    def origin_allowed?
      return true if @allowed_origins.empty?
      @allowed_origins.include?(@origin)
    end
  end
end
