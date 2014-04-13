module VegaServer::Events
  class Open
    include Handleable

    def initialize(websocket, event)
      @origin          = event.origin
      @allowed_origins = VegaServer.allowed_origins

      super
    end

    def handle
      if !origin_allowed?
        @websocket.close
        @websocket = nil
      end
    end

    private

    def origin_allowed?
      return true if @allowed_origins.empty?
      @allowed_origins.include?(@origin)
    end
  end
end
