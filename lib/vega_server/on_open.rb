module VegaServer
  class OnOpen
    def initialize(ws, origin)
      @ws              = ws
      @origin          = origin
      @allowed_origins = VegaServer.allowed_origins
    end

    def call
      @ws.on :open do
        if !origin_allowed?
          @ws.close
          @ws = nil
        end
      end
    end

    def self.call(ws, origin)
      new(ws, origin).call
    end

    private

    def origin_allowed?
      return true if @allowed_origins.empty?
      @allowed_origins.include?(@origin)
    end
  end
end
